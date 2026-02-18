# SecureLLM Gateway
**AI Middleware for  PII Compliance**

[![Vercel](https://img.shields.io/badge/Vercel-000000?style=for-the-badge&logo=vercel&logoColor=white)](https://secure-llm-gateway.vercel.app/)

[![Render](https://img.shields.io/badge/Render-46E3B7?style=for-the-badge&logo=render&logoColor=white)](https://secure-llm-gateway.onrender.com/)

> [!NOTE]
> **Status:** Backend deployment is currently undergoing maintenance to resolve a platform-specific dependency issue on Render. Please refer to the screenshot below to see the frontend interface interacting with the sanitized response.


### Executive Summary
Architected a centralized AI Gateway utilizing **Ruby on Rails 8** and **React** to standardize LLM interactions across multiple providers. This system significantly reduces API sprawl and enhances developer velocity by providing a unified, secure interface for AI integration.

The gateway features a real-time **PII Sanitization Engine** utilizing **Named Entity Recognition (NER)** to intercept "in-flight" requests and redact sensitive financial entities—ensuring Zero-Trust data privacy before data egress.

### System Interface
![SecureLLM Gateway Demo](assets/demo-screenshot.png)
*Figure 1: Real-time redaction of sensitive identity information while preserving conversational utility.*

### Key Technical Features

* **NER-Driven PII Redaction:** Engineered a sanitization engine that intercepts requests to redact sensitive entities (Emails, Phone Numbers, Credit Cards, SINs), ensuring no PII reaches third-party model providers.
* **Automated Audit & Observability:** Developed a PostgreSQL-backed logging layer that tracks request metadata, token consumption, and model latency, providing full visibility into system health and operational costs.
* **Latency Optimization:** Optimized system throughput by leveraging **Groq's Llama-3** inference engine to achieve sub-500ms end-to-end processing.
* **Standardized AI Interface:** Built a modular backend that decouples application logic from specific LLM providers, allowing for seamless model swapping and testing.

### Local Development Setup

Follow these steps to run the gateway locally on your machine.

#### 1. Prerequisites
* Ruby 3.3+
* Node.js 18+
* PostgreSQL
* Groq API Key (for LLM inference)

#### 2. Backend Setup (Rails API)
The backend handles sanitization, LLM proxying, and audit logging.

```bash
# Navigate to the backend directory
cd backend

# Install Ruby dependencies
bundle install

# Setup the database
rails db:create
rails db:migrate

# Start the Rails server
rails s
```

The backend will run on `http://localhost:3000`

#### 3. Frontend Setup (React + Vite)
The frontend provides the chat interface and latency visualization.

```bash
# Open a new terminal and navigate to the frontend directory
cd frontend

# Install Node dependencies
npm install

# Start the development server
npm run dev
```
The frontend will run on `http://localhost:5173`

#### 4. Environment Variables
Create a `.env` file in the `backend/` directory or use rails credentials:edit to set the following secrets:

```bash
GROQ_API_KEY	Required. API key from Groq Console for Llama-3 inference.

```

#### System Architecture

```mermaid
sequenceDiagram
    participant User as React Frontend
    participant API as Rails Gateway
    participant PII as Sanitization Engine (NER)
    participant LLM as Groq (Llama-3)
    participant DB as PostgreSQL Audit

    User->>API: Submit Prompt (contains PII)
    API->>PII: Intercept & Detect Entities
    PII-->>API: Return Redacted Prompt
    API->>LLM: Forward Secure Request
    LLM-->>API: AI Response
    API->>DB: Log Latency, Tokens & Cost
    API->>User: Secure AI Response
