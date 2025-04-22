# api/job.py

import subprocess
import re
from s4e.task import Task

SYSTEM_INSTRUCTION = (
    "You are a helpful AI assistant who ONLY generates Python code. "
    "You do not answer general questions or do anything unrelated to Python code generation. "
    "If the user asks a non-Python-related question, respond with:\n"
    "\"Sorry, I only generate Python code.\""
)

def call_llm(prompt: str) -> str:
    """
    Calls Ollama’s CLI to generate a response.
    Returns stdout if successful, or a combined error message.
    """
    full_prompt = f"{SYSTEM_INSTRUCTION}\n\nUser prompt: {prompt}"
    
    try:
        proc = subprocess.run(
            ["ollama", "run", "llama2", full_prompt],
            capture_output=True,
            text=True,
            check=True
        )
        return proc.stdout
    except subprocess.CalledProcessError as e:
        # Log stdout and stderr for debugging
        debug = (
            f"LLM_CALL_ERROR\n"
            f"STDOUT:\n{e.stdout}\n"
            f"STDERR:\n{e.stderr}"
        )
        return debug

def parse_response(text: str) -> tuple[str, str]:
    """
    Expects the model to output:
       Title: <heading>
       ```python
       <code>
       ```
    Pulls out that heading and the code inside backticks.
    """
    m_title = re.search(r"^Title:\s*(.+)$", text, re.MULTILINE)
    title = m_title.group(1).strip() if m_title else "Generated Code"

    m_code = re.search(r"```(?:python)?\s*([\s\S]+?)```", text)
    code = m_code.group(1).rstrip() if m_code else text

    return title, code

class Job(Task):
    def run(self):
        prompt = self.param.get('prompt', '')
        llm_output = call_llm(prompt)

        title, code = parse_response(llm_output)
        self.output['title'] = title
        self.output['code']  = code.splitlines()

    def calculate_score(self):
        # one point per 10 lines, max 10
        self.score = min(10, len(self.output.get('

