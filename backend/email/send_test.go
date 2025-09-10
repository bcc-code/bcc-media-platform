package email

import (
	"context"
	"errors"
	"testing"

	"github.com/stretchr/testify/assert"
	"github.com/stretchr/testify/mock"
	"github.com/stretchr/testify/require"
)

// MockEmailProvider implements the EmailProvider interface for testing
type MockEmailProvider struct {
	mock.Mock
}

func (m *MockEmailProvider) SendEmail(ctx context.Context, options SendOptions) error {
	args := m.Called(ctx, options)
	return args.Error(0)
}

func TestService_SendEmail(t *testing.T) {
	tests := []struct {
		name        string
		options     SendOptions
		setupMock   func(*MockEmailProvider)
		expectError bool
		errorMsg    string
	}{
		{
			name: "successful email send",
			options: SendOptions{
				From: Recipient{
					Name:  "Test Sender",
					Email: "sender@example.com",
				},
				To: Recipient{
					Name:  "Test Recipient",
					Email: "recipient@example.com",
				},
				Title:       "Test Subject",
				Content:     "Test plain text content",
				HTMLContent: "<p>Test HTML content</p>",
			},
			setupMock: func(mockProvider *MockEmailProvider) {
				mockProvider.On("SendEmail", mock.Anything, mock.AnythingOfType("SendOptions")).Return(nil)
			},
			expectError: false,
		},
		{
			name: "provider error is propagated",
			options: SendOptions{
				From: Recipient{
					Name:  "Test Sender",
					Email: "sender@example.com",
				},
				To: Recipient{
					Name:  "Test Recipient",
					Email: "recipient@example.com",
				},
				Title:       "Test Subject",
				Content:     "Test content",
				HTMLContent: "<p>Test HTML content</p>",
			},
			setupMock: func(mockProvider *MockEmailProvider) {
				mockProvider.On("SendEmail", mock.Anything, mock.AnythingOfType("SendOptions")).Return(errors.New("provider error"))
			},
			expectError: true,
			errorMsg:    "provider error",
		},
		{
			name: "context is passed to provider",
			options: SendOptions{
				From: Recipient{
					Email: "sender@example.com",
				},
				To: Recipient{
					Email: "recipient@example.com",
				},
				Title:   "Test Subject",
				Content: "Test content",
			},
			setupMock: func(mockProvider *MockEmailProvider) {
				mockProvider.On("SendEmail", mock.AnythingOfType("*context.valueCtx"), mock.AnythingOfType("SendOptions")).Return(nil)
			},
			expectError: false,
		},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			mockProvider := &MockEmailProvider{}
			tt.setupMock(mockProvider)

			service := &Service{
				provider: mockProvider,
			}

			ctx := context.WithValue(context.Background(), "test", "value")
			err := service.SendEmail(ctx, tt.options)

			if tt.expectError {
				assert.Error(t, err)
				if tt.errorMsg != "" {
					assert.Contains(t, err.Error(), tt.errorMsg)
				}
			} else {
				assert.NoError(t, err)
			}

			mockProvider.AssertExpectations(t)
		})
	}
}

func TestService_SendEmail_Integration(t *testing.T) {
	// Integration test that creates a real service and tests the flow
	service, err := New(Config{
		Provider:       "sendgrid",
		SendGridAPIKey: "fake_api_key_for_test",
	})
	require.NoError(t, err)
	require.NotNil(t, service)

	// This will fail because we're using a fake API key, but it tests the integration
	ctx := context.Background()
	options := SendOptions{
		From: Recipient{
			Name:  "Test Sender",
			Email: "sender@example.com",
		},
		To: Recipient{
			Name:  "Test Recipient",
			Email: "recipient@example.com",
		},
		Title:       "Integration Test",
		Content:     "This is an integration test",
		HTMLContent: "<p>This is an <strong>integration test</strong></p>",
	}

	err = service.SendEmail(ctx, options)
	// We expect this to fail with a SendGrid error due to fake API key
	assert.Error(t, err)
}

func TestSendOptions_Validation(t *testing.T) {
	// Test different combinations of SendOptions to ensure they're handled properly
	mockProvider := &MockEmailProvider{}
	service := &Service{provider: mockProvider}
	ctx := context.Background()

	tests := []struct {
		name    string
		options SendOptions
		valid   bool
	}{
		{
			name: "minimal valid options",
			options: SendOptions{
				From:    Recipient{Email: "from@example.com"},
				To:      Recipient{Email: "to@example.com"},
				Title:   "Subject",
				Content: "Content",
			},
			valid: true,
		},
		{
			name: "with HTML content",
			options: SendOptions{
				From:        Recipient{Email: "from@example.com"},
				To:          Recipient{Email: "to@example.com"},
				Title:       "Subject",
				Content:     "Plain text",
				HTMLContent: "<p>HTML content</p>",
			},
			valid: true,
		},
		{
			name: "with names",
			options: SendOptions{
				From:    Recipient{Name: "Sender Name", Email: "from@example.com"},
				To:      Recipient{Name: "Recipient Name", Email: "to@example.com"},
				Title:   "Subject",
				Content: "Content",
			},
			valid: true,
		},
		{
			name: "empty options",
			options: SendOptions{},
			valid: true, // The provider will handle validation
		},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			if tt.valid {
				mockProvider.On("SendEmail", ctx, tt.options).Return(nil).Once()
			}

			err := service.SendEmail(ctx, tt.options)

			if tt.valid {
				assert.NoError(t, err)
			} else {
				assert.Error(t, err)
			}
		})
	}

	mockProvider.AssertExpectations(t)
}