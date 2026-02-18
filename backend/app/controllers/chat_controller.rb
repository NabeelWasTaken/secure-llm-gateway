class ChatController < ApplicationController
  def create
    start_time = Time.now

    # 1. Capture Input
    user_prompt = params[:prompt]

    # 2. Security Layer (The Sanitizer)
    sanitized_content = PiiSanitizerService.new(user_prompt).call

    # 3. Gateway Layer (Placeholder for OpenAI Call)
    # We will replace this with the real API call in the next phase
    mock_response = "This is a simulated response"
    
    # 4. Calculate Metrics (Simulated for now)
    latency = (Time.now - start_time) * 1000 # Convert to milliseconds

    # 5. Observability Layer (Log everything to Postgres)
    RequestLog.create!(
      original_prompt: user_prompt,
      sanitized_prompt: sanitized_content,
      llm_response: mock_response,
      provider: "simulation",
      prompt_tokens: user_prompt.split.size, # Rough estimate
      completion_tokens: 10,
      total_cost: 0.0002, # Fake cost
      latency: latency
    )

    # 6. Return Response
    render json: { 
      status: "success",
      sanitized_prompt: sanitized_content,
      response: mock_response
    }, status: :ok
  end
end