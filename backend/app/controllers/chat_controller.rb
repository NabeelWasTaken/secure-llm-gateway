class ChatController < ApplicationController
  def create
    start_time = Time.now

    # 1. Capture Input
    user_prompt = params[:prompt]

    # 2. Security Layer (The Sanitizer)
    sanitized_content = PiiSanitizerService.new(user_prompt).call

    # 3. Gateway Layer: Initialize the client to talk to Groq
    client = OpenAI::Client.new(
      access_token: ENV.fetch("GROQ_API_KEY"),
      uri_base: "https://api.groq.com/openai" # This tells the gem to talk to Groq
    )
    
    # 3. Execution: Send the SANITIZED prompt to the AI
    response = client.chat(
      parameters: {
        model: "llama-3.3-70b-versatile", 
        messages: [{ role: "user", content: sanitized_content }],
        temperature: 0.7
      }
    )

    # 4. Extraction: Get the AI's text and token usage from the JSON response
    llm_response = response.dig("choices", 0, "message", "content")
    prompt_tokens = response.dig("usage", "prompt_tokens")
    completion_tokens = response.dig("usage", "completion_tokens")
    
    latency = (Time.now - start_time) * 1000 # milliseconds

    # 5. Audit Layer: Save the real metrics to your Postgres database
    RequestLog.create!(
      original_prompt: user_prompt,
      sanitized_prompt: sanitized_content,
      llm_response: llm_response,
      provider: "groq",
      prompt_tokens: prompt_tokens,
      completion_tokens: completion_tokens,
      latency: latency
    )

    # 6. Response: Send everything back to the user
    render json: { 
      status: "success",
      sanitized_prompt: sanitized_content,
      response: llm_response,
      metrics: { 
        latency_ms: latency.round(2),
        tokens: prompt_tokens + completion_tokens
      }
    }
  rescue => e
    render json: { status: "error", message: e.message }, status: :unprocessable_entity
  end
end