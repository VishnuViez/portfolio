package com.vishnu.ecommerce.ui.auth

import android.content.Intent
import android.os.Bundle
import android.widget.Toast
import androidx.activity.viewModels
import androidx.appcompat.app.AppCompatActivity
import androidx.lifecycle.lifecycleScope
import com.vishnu.ecommerce.databinding.ActivityLoginBinding
import com.vishnu.ecommerce.ui.home.MainActivity
import com.vishnu.ecommerce.utils.Resource
import com.vishnu.ecommerce.utils.gone
import com.vishnu.ecommerce.utils.visible
import dagger.hilt.android.AndroidEntryPoint
import kotlinx.coroutines.launch

@AndroidEntryPoint
class LoginActivity : AppCompatActivity() {

    private lateinit var binding: ActivityLoginBinding
    private val viewModel: AuthViewModel by viewModels()

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        if (viewModel.isLoggedIn()) {
            navigateToMain()
            return
        }

        binding = ActivityLoginBinding.inflate(layoutInflater)
        setContentView(binding.root)

        setupViews()
        observeAuth()
    }

    private fun setupViews() {
        binding.btnLogin.setOnClickListener {
            val email = binding.etEmail.text.toString().trim()
            val password = binding.etPassword.text.toString().trim()
            if (email.isNotEmpty() && password.isNotEmpty()) {
                viewModel.login(email, password)
            } else {
                Toast.makeText(this, "Please fill all fields", Toast.LENGTH_SHORT).show()
            }
        }

        binding.tvRegister.setOnClickListener {
            val email = binding.etEmail.text.toString().trim()
            val password = binding.etPassword.text.toString().trim()
            val name = binding.etName.text.toString().trim()
            if (email.isNotEmpty() && password.isNotEmpty()) {
                viewModel.register(email, password, name)
            }
        }

        binding.btnSkipLogin.setOnClickListener {
            navigateToMain()
        }
    }

    private fun observeAuth() {
        lifecycleScope.launch {
            viewModel.authState.collect { state ->
                when (state) {
                    is Resource.Loading -> {
                        binding.progressBar.visible()
                        binding.btnLogin.isEnabled = false
                    }
                    is Resource.Success -> {
                        binding.progressBar.gone()
                        binding.btnLogin.isEnabled = true
                        navigateToMain()
                    }
                    is Resource.Error -> {
                        binding.progressBar.gone()
                        binding.btnLogin.isEnabled = true
                        Toast.makeText(this@LoginActivity, state.message, Toast.LENGTH_LONG).show()
                    }
                    is Resource.Idle -> {
                        // No operation in progress, ensure UI is interactive
                        binding.progressBar.gone()
                        binding.btnLogin.isEnabled = true
                    }
                }
            }
        }
    }

    private fun navigateToMain() {
        startActivity(Intent(this, MainActivity::class.java))
        finish()
    }
}
