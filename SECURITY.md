## Security

If you discover a security vulnerability, please do not open a public issue. Contact the maintainers directly or use an email address listed in the project repository (or use GitHub security advisory flow).

Include a clear description, steps to reproduce and any PoC you can share privately.

## Security Best Practices

When using feda_flutter in production, follow these security best practices:

### API Key Management
- **Never hardcode API keys** in your application code
- Use environment variables or secure storage (e.g., Flutter Secure Storage)
- Consider implementing a backend token exchange service (see example/dart_frog_api/)
- Use sandbox keys for development and testing only

### WebView Security (PayWidget)
The PayWidget component includes several security measures:
- **Domain whitelisting**: Only allows navigation to fedapay.com domains
- **URL validation**: Validates payment URLs before loading
- **Secure payment flow**: Uses token-based payment URLs

### Network Security
- All API calls use HTTPS with Bearer token authentication
- API keys are masked in debug logs
- Implement certificate pinning for additional security in production (not included in base package)

### Data Protection
- Avoid logging sensitive payment information
- Validate all user inputs before sending to the API
- Use the callback URL mechanism to receive payment confirmations server-side
