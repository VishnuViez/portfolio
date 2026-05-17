const { onDocumentCreated } = require("firebase-functions/v2/firestore");
const { initializeApp } = require("firebase-admin/app");
const { getFirestore } = require("firebase-admin/firestore");
const { getMessaging } = require("firebase-admin/messaging");

initializeApp();

const db = getFirestore();

/**
 * Triggered whenever a new message document is created inside any chat room.
 * Sends an FCM push notification to every participant (except the sender)
 * who has a valid fcmToken stored in their user document.
 */
exports.onNewMessage = onDocumentCreated(
  "chatRooms/{roomId}/messages/{messageId}",
  async (event) => {
    const snapshot = event.data;
    if (!snapshot) return;

    const messageData = snapshot.data();
    const roomId = event.params.roomId;
    const senderId = messageData.senderId || "";
    const senderName = messageData.senderName || "Someone";
    const content = messageData.content || "";

    // Get the chat room to find all participants
    const roomDoc = await db.collection("chatRooms").doc(roomId).get();
    if (!roomDoc.exists) {
      console.log(`Room ${roomId} not found`);
      return;
    }

    const roomData = roomDoc.data();
    const participants = roomData.participants || [];

    // Collect FCM tokens for all participants except the sender
    const tokens = [];
    for (const userId of participants) {
      if (userId === senderId) continue;

      const userDoc = await db.collection("users").doc(userId).get();
      if (!userDoc.exists) continue;

      const userData = userDoc.data();
      const token = userData.fcmToken;
      if (token && token.length > 0) {
        tokens.push(token);
      }
    }

    if (tokens.length === 0) {
      console.log("No FCM tokens to send to");
      return;
    }

    // Build the FCM message payload (data-only so the app handles display)
    const message = {
      tokens: tokens,
      data: {
        roomId: roomId,
        senderId: senderId,
        senderName: senderName,
        content: content,
        timestamp: String(messageData.timestamp || Date.now()),
      },
      notification: {
        title: senderName,
        body: content,
      },
      android: {
        priority: "high",
        notification: {
          channelId: "chat_messages",
          priority: "high",
          defaultSound: true,
        },
      },
    };

    try {
      const response = await getMessaging().sendEachForMulticast(message);
      console.log(
        `Sent ${response.successCount} notifications, ${response.failureCount} failures`
      );

      // Clean up invalid tokens
      response.responses.forEach((resp, idx) => {
        if (
          resp.error &&
          (resp.error.code === "messaging/invalid-registration-token" ||
            resp.error.code === "messaging/registration-token-not-registered")
        ) {
          console.log(`Removing invalid token: ${tokens[idx]}`);
          // Find the user with this token and clear it
          db.collection("users")
            .where("fcmToken", "==", tokens[idx])
            .get()
            .then((snap) => {
              snap.forEach((doc) => {
                doc.ref.update({ fcmToken: "" });
              });
            });
        }
      });
    } catch (error) {
      console.error("Error sending FCM notifications:", error);
    }
  }
);

/**
 * Triggered whenever a new call document is created in the "calls" collection.
 * Sends a high-priority FCM push notification to the callee so their device
 * wakes up and shows the incoming call UI.
 */
exports.onNewCall = onDocumentCreated(
  "calls/{callId}",
  async (event) => {
    const snapshot = event.data;
    if (!snapshot) return;

    const callData = snapshot.data();
    const callId = event.params.callId;
    const callerId = callData.callerId || "";
    const callerName = callData.callerName || "Someone";
    const calleeId = callData.calleeId || "";
    const callType = callData.callType || "AUDIO";
    const status = callData.status || "RINGING";

    // Only send notification for new ringing calls
    if (status !== "RINGING") {
      console.log(`Call ${callId} status is ${status}, skipping notification`);
      return;
    }

    if (!calleeId) {
      console.log(`Call ${callId} has no calleeId`);
      return;
    }

    // Get callee's FCM token
    const calleeDoc = await db.collection("users").doc(calleeId).get();
    if (!calleeDoc.exists) {
      console.log(`Callee ${calleeId} not found`);
      return;
    }

    const calleeData = calleeDoc.data();
    const token = calleeData.fcmToken;
    if (!token || token.length === 0) {
      console.log(`Callee ${calleeId} has no FCM token`);
      return;
    }

    const message = {
      token: token,
      data: {
        type: "call",
        callId: callId,
        callerId: callerId,
        callerName: callerName,
        calleeId: calleeId,
        callType: callType,
        timestamp: String(callData.timestamp || Date.now()),
      },
      android: {
        priority: "high",
        notification: {
          channelId: "incoming_calls",
          priority: "max",
          defaultSound: true,
          visibility: "public",
          title: `Incoming ${callType === "VIDEO" ? "Video" : "Audio"} Call`,
          body: `${callerName} is calling...`,
        },
      },
    };

    try {
      await getMessaging().send(message);
      console.log(`Call notification sent to ${calleeId} for call ${callId}`);
    } catch (error) {
      console.error(`Error sending call notification for ${callId}:`, error);

      // Clean up invalid token
      if (
        error.code === "messaging/invalid-registration-token" ||
        error.code === "messaging/registration-token-not-registered"
      ) {
        console.log(`Removing invalid token for user ${calleeId}`);
        await db.collection("users").doc(calleeId).update({ fcmToken: "" });
      }
    }
  }
);
