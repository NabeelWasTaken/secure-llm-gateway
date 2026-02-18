class PiiSanitizerService
  def initialize(content)
    @content = content
  end

  def call
    redact_emails
    redact_phone_numbers
    @content
  end

  private

  def redact_emails
    # Regex for email addresses
    email_regex = /\b[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,}\b/i
    @content = @content.gsub(email_regex, "[REDACTED_EMAIL]")
  end

  def redact_phone_numbers
    # Regex for various phone formats (e.g., 123-456-7890, (123) 456-7890)
    phone_regex = /\b(?:\+?1[-. ]?)?\(?([0-9]{3})\)?[-. ]?([0-9]{3})[-. ]?([0-9]{4})\b/
    @content = @content.gsub(phone_regex, "[REDACTED_PHONE]")
  end
end