package email

import (
	"context"
	"os"
	"testing"
	"time"

	"github.com/stretchr/testify/assert"
)

// These are integration tests that use Resend's test email addresses
// They require a real Resend API key to run
// Set RESEND_TEST_API_KEY environment variable to run these tests

func TestResendProvider_TestEmailAddresses_Integration(t *testing.T) {
	apiKey := os.Getenv("RESEND_TEST_API_KEY")
	if apiKey == "" {
		t.Skip("RESEND_TEST_API_KEY environment variable not set, skipping integration tests")
	}

	provider := NewResendProvider(apiKey, "test@mailer.bcc.media")
	ctx := context.Background()

	tests := []struct {
		name        string
		toEmail     string
		expectError bool
		description string
	}{
		{
			name:        "delivered test email",
			toEmail:     "delivered@resend.dev",
			expectError: false,
			description: "Should successfully send to delivered test address",
		},
		{
			name:        "delivered with label",
			toEmail:     "delivered+integration-test@resend.dev",
			expectError: false,
			description: "Should successfully send to delivered test address with label",
		},
		{
			name:        "bounced test email",
			toEmail:     "bounced@resend.dev",
			expectError: false, // API call succeeds, but email will bounce
			description: "Should accept bounced test address (bounce happens later)",
		},
		{
			name:        "bounced with label",
			toEmail:     "bounced+integration-test@resend.dev",
			expectError: false, // API call succeeds, but email will bounce
			description: "Should accept bounced test address with label",
		},
		{
			name:        "complained test email",
			toEmail:     "complained@resend.dev",
			expectError: false, // API call succeeds, but email will be marked as spam
			description: "Should accept complained test address (complaint happens later)",
		},
		{
			name:        "complained with label",
			toEmail:     "complained+integration-test@resend.dev",
			expectError: false, // API call succeeds, but email will be marked as spam
			description: "Should accept complained test address with label",
		},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			options := SendOptions{
				From: Recipient{
					Name:  "Integration Test",
					Email: "onboarding@resend.dev", // Use Resend's test from address
				},
				To: Recipient{
					Name:  "Test Recipient",
					Email: tt.toEmail,
				},
				Title: "Integration Test - " + tt.name,
				Content: `This is a test email sent from the Resend provider integration test.

Email type: ` + tt.name + `
Test address: ` + tt.toEmail + `
Time: ` + time.Now().Format(time.RFC3339),
				HTMLContent: `<html>
<body>
	<h1>Integration Test - ` + tt.name + `</h1>
	<p>This is a <strong>test email</strong> sent from the Resend provider integration test.</p>
	<ul>
		<li><strong>Email type:</strong> ` + tt.name + `</li>
		<li><strong>Test address:</strong> ` + tt.toEmail + `</li>
		<li><strong>Time:</strong> ` + time.Now().Format(time.RFC3339) + `</li>
	</ul>
	
	<p>This email tests different Resend behaviors:</p>
	<ul>
		<li><code>delivered@resend.dev</code> - Simulates successful delivery</li>
		<li><code>bounced@resend.dev</code> - Simulates bounced emails</li>
		<li><code>complained@resend.dev</code> - Simulates spam complaints</li>
	</ul>
</body>
</html>`,
			}

			err := provider.SendEmail(ctx, options)

			if tt.expectError {
				assert.Error(t, err, tt.description)
			} else {
				assert.NoError(t, err, tt.description)
				t.Logf("Successfully sent test email to %s", tt.toEmail)
			}

			// Add delay between requests to avoid rate limiting (2 requests/second limit)
			time.Sleep(600 * time.Millisecond)
		})
	}
}

func TestResendProvider_RealWorldScenarios_Integration(t *testing.T) {
	apiKey := os.Getenv("RESEND_TEST_API_KEY")
	if apiKey == "" {
		t.Skip("RESEND_TEST_API_KEY environment variable not set, skipping integration tests")
	}

	provider := NewResendProvider(apiKey, "test@mailer.bcc.media")
	ctx := context.Background()

	t.Run("email with various content types", func(t *testing.T) {
		options := SendOptions{
			From: Recipient{
				Name:  "BrunstadTV Test",
				Email: "onboarding@resend.dev",
			},
			To: Recipient{
				Name:  "Test User",
				Email: "delivered@resend.dev",
			},
			Title:   "🎬 BrunstadTV - Test Email with Special Characters & HTML",
			Content: "Plain text version:\n\n- Welcome to BrunstadTV!\n- This email contains special characters: æøå ñüé\n- Unicode symbols: 🎬📺✨\n- And various formatting tests",
			HTMLContent: `<html>
<head>
	<meta charset="UTF-8">
	<title>BrunstadTV Test Email</title>
</head>
<body>
	<h1>🎬 Welcome to BrunstadTV!</h1>
	
	<p>This is a test email with <strong>various content types</strong>:</p>
	
	<h2>Special Characters</h2>
	<p>Norwegian: æøå</p>
	<p>Spanish: ñüé</p>
	<p>German: äöü</p>
	
	<h2>Unicode Symbols</h2>
	<p>🎬 📺 ✨ 🌟 💫</p>
	
	<h2>Formatting</h2>
	<ul>
		<li><strong>Bold text</strong></li>
		<li><em>Italic text</em></li>
		<li><code>Code text</code></li>
	</ul>
	
	<h2>Links</h2>
	<p><a href="https://brunstad.tv">Visit BrunstadTV</a></p>
	
	<h2>Table</h2>
	<table border="1" style="border-collapse: collapse;">
		<tr>
			<th>Show</th>
			<th>Language</th>
			<th>Duration</th>
		</tr>
		<tr>
			<td>Test Show</td>
			<td>English</td>
			<td>30 min</td>
		</tr>
	</table>
	
	<hr>
	<p><small>This is a test email from the BrunstadTV platform integration tests.</small></p>
</body>
</html>`,
		}

		err := provider.SendEmail(ctx, options)
		assert.NoError(t, err, "Should handle complex HTML and special characters")
		
		// Rate limit protection
		time.Sleep(600 * time.Millisecond)
	})

	t.Run("email with malicious content sanitization", func(t *testing.T) {
		options := SendOptions{
			From: Recipient{
				Name:  "Security Test",
				Email: "onboarding@resend.dev",
			},
			To: Recipient{
				Name:  "Security Tester",
				Email: "delivered@resend.dev",
			},
			Title:   "Security Test - HTML Sanitization",
			Content: "This email tests HTML sanitization.",
			HTMLContent: `<html>
<body>
	<h1>Security Test</h1>
	<p>This email contains potentially dangerous HTML that should be sanitized:</p>
	
	<!-- These should be sanitized by bluemonday -->
	<script>alert('XSS attempt')</script>
	<img src="x" onerror="alert('XSS')">
	<a href="javascript:alert('XSS')">Malicious Link</a>
	<object data="data:text/html,<script>alert('XSS')</script>"></object>
	<embed src="data:text/html,<script>alert('XSS')</script>">
	
	<!-- These should be kept -->
	<p><strong>Bold text is safe</strong></p>
	<p><em>Italic text is safe</em></p>
	<ul>
		<li>List items are safe</li>
	</ul>
	<a href="https://brunstad.tv">Safe links are preserved</a>
</body>
</html>`,
		}

		err := provider.SendEmail(ctx, options)
		assert.NoError(t, err, "Should sanitize malicious content and send safely")
		
		// Rate limit protection
		time.Sleep(600 * time.Millisecond)
	})
}

func TestResendProvider_ErrorHandling_Integration(t *testing.T) {
	// Test with invalid API key
	provider := NewResendProvider("invalid_api_key_12345", "test@mailer.bcc.media")
	ctx := context.Background()

	options := SendOptions{
		From: Recipient{
			Email: "onboarding@resend.dev",
		},
		To: Recipient{
			Email: "delivered@resend.dev",
		},
		Title:   "Test Email with Invalid API Key",
		Content: "This should fail",
	}

	err := provider.SendEmail(ctx, options)
	assert.Error(t, err, "Should fail with invalid API key")
	assert.Contains(t, err.Error(), "Resend API error", "Error should indicate it's a Resend API error")

	t.Logf("Error message: %v", err)
}