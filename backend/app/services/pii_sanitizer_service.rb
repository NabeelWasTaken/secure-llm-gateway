require 'pragmatic_segmenter'

class PiiSanitizerService
  def initialize(content)
    @content = content
  end

  def call
    # 1. Patterns for fixed PII
    redact_emails
    redact_phone_numbers
    redact_credit_cards   # NEW
    redact_ssn            # NEW
    redact_passports      # NEW
    

    
    @content
  end

  private

  # Detects Visa, Mastercard, Amex, and Discover
  def redact_credit_cards
    cc_regex = /\b(?:4[0-9]{12}(?:[0-9]{3})?|5[1-5][0-9]{14}|3[47][0-9]{13}|6(?:011|5[0-9]{2})[0-9]{12})\b/
    @content = @content.gsub(cc_regex, "[REDACTED_CREDIT_CARD]")
  end

  # Detects SSN (US) and SIN (Canada) formats: XXX-XXX-XXX or XXX-XX-XXXX
  def redact_ssn
    ssn_regex = /\b(?:\d{3}-\d{2}-\d{4}|\d{3}-\d{3}-\d{3})\b/
    @content = @content.gsub(ssn_regex, "[REDACTED_GOVT_ID]")
  end

  # Detects generic Passport number patterns (Alphanumeric 6-9 chars)
  def redact_passports
    passport_regex = /\b[A-Z]{1,2}[0-9]{6,8}\b/
    @content = @content.gsub(passport_regex, "[REDACTED_PASSPORT]")
  end
  
  def redact_emails
    email_regex = /\b[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,}\b/i
    @content = @content.gsub(email_regex, "[REDACTED_EMAIL]")
  end

  def redact_phone_numbers
    phone_regex = /\b(?:\+?1[-. ]?)?\(?([0-9]{3})\)?[-. ]?([0-9]{3})[-. ]?([0-9]{4})\b/
    @content = @content.gsub(phone_regex, "[REDACTED_PHONE]")
  end
end