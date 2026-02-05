# Security Policy

## Supported Versions

| Version | Supported          |
|---------|--------------------|
| 0.9.x   | :white_check_mark: |
| 0.8.x   | :white_check_mark: |
| < 0.8   | :x:                |

## Reporting a Vulnerability

We take security seriously. If you discover a security vulnerability, please follow these steps:

### Do NOT

- Open a public GitHub issue
- Post about it on social media
- Exploit the vulnerability

### Do

1. **Email us** at [security@example.com] with:
   - Description of the vulnerability
   - Steps to reproduce
   - Potential impact
   - Your suggested fix (if any)

2. **Allow time** for us to respond (typically within 48 hours)

3. **Work with us** to understand and address the issue

### What to Expect

- **Acknowledgment**: Within 48 hours
- **Initial Assessment**: Within 1 week
- **Resolution Timeline**: Depends on severity
- **Credit**: We'll credit you in our changelog (unless you prefer anonymity)

## Security Best Practices

### For Contributors

1. **Never commit secrets**
   - API keys, tokens, passwords
   - Use environment variables or `--dart-define`
   - Add sensitive files to `.gitignore`

2. **Validate user input**
   - Sanitize data before processing
   - Use parameterized queries for database operations

3. **Keep dependencies updated**
   - Regularly run `flutter pub outdated`
   - Check for security advisories

4. **Follow secure coding practices**
   - Avoid storing sensitive data in plain text
   - Use HTTPS for all network requests
   - Implement proper error handling (don't leak sensitive info)

### For Users

1. **Download from official sources**
   - Use official app stores when available
   - Verify the publisher

2. **Keep the app updated**
   - Install updates promptly
   - Updates often contain security fixes

3. **Report suspicious behavior**
   - If something seems wrong, let us know

## Data Privacy

TimeWalker handles the following data:

| Data Type | Storage | Purpose |
|-----------|---------|---------|
| Game progress | Local (Hive) / Remote (Supabase) | Save user progress |
| Preferences | Local (Hive) | App settings |
| Analytics (future) | Remote | Improve user experience |

We do NOT collect:
- Personal identification information (unless auth is implemented)
- Location data
- Contacts or device data

## Third-Party Dependencies

We use these external services:

| Service | Purpose | Security Notes |
|---------|---------|----------------|
| Supabase | Backend | Row Level Security enabled |
| Hive | Local storage | Can be encrypted |

## Acknowledgments

We thank the following individuals for responsibly disclosing security issues:

- *No reports yet*

---

Thank you for helping keep TimeWalker secure!
