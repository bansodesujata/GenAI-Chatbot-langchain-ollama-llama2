#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

echo "🔧 Starting Langchain Bot Deployment..."

# Step 1: Create virtual environment
echo "📦 Creating virtual environment..."
python3 -m venv langchain_env
source langchain_env/bin/activate

# Step 2: Upgrade pip
echo "⬆️ Upgrading pip..."
pip install --upgrade pip

# Step 3: Install dependencies
echo "📚 Installing required Python packages..."
pip install streamlit langchain langchain-openai langchain-community python-dotenv

# Step 4: Load environment variables
echo "🔐 Setting up environment variables..."
if [ ! -f .env ]; then
  echo "Creating .env file..."
  cat <<EOT >> .env
OPENAI_API_KEY=your_openai_api_key_here
LANGCHAIN_API_KEY=your_langchain_api_key_here
EOT
  echo "⚠️ Please update .env with your actual API keys."
fi

# Step 5: Install and configure Ollama
echo "🦙 Checking Ollama installation..."
if ! command -v ollama &> /dev/null; then
  echo "Installing Ollama..."
  curl -fsSL https://ollama.com/install.sh | sh
else
  echo "✅ Ollama is already installed."
fi

echo "📥 Pulling Llama2 model with Ollama..."
ollama pull llama2

# Step 6: Run the bots
echo "🚀 Launching Langchain Bots..."

echo "🔹 Starting OpenAI Bot (app.py)..."
streamlit run app.py &

echo "🔸 Starting Llama2 Bot (ollama.py)..."
streamlit run ollama.py &

echo "✅ Deployment complete. Both bots are running in your browser."