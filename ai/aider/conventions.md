# When writing python code, you MUST follow these principles

## General

- DO NOT remove any comments unless asked
- ONLY make requested changes. DO NOT make any changes unless they are directly related to the user's request

## Python Libraries

- Always create a `requirements.txt` file if one does not already exist
- When adding libraries to `requirements.txt` do not include specific versions, always use the latest. For example:

```requirements.txt
requests
openai
httpx
```

## OpenAI API

- Use the OpenAI Responses API for all LLM calls; do not use the Chat Completions API. <https://platform.openai.com/docs/guides/text?api-mode=responses>
- Default to the model `gpt-4.1` for all requests.

## Basic completion example

```python
from openai import OpenAI
client = OpenAI()

response = client.responses.create(
    model="gpt-4.1",
    input="Write a one-sentence bedtime story about a unicorn."
)

print(response.output_text)
```

- output:

```json
[
    {
        "id": "msg_67b73f697ba4819183a15cc17d011509",
        "type": "message",
        "role": "assistant",
        "content": [
            {
                "type": "output_text",
                "text": "Under the soft glow of the moon, Luna the unicorn danced through fields of twinkling stardust, leaving trails of dreams for every child asleep.",
                "annotations": []
            }
        ]
    }
]
```

## Streaming responses

```python
from openai import OpenAI
client = OpenAI()

stream = client.responses.create(
    model="gpt-4.1",
    input=[
        {
            "role": "user",
            "content": "Say 'double bubble bath' ten times fast.",
        },
    ],
    stream=True,
)

for event in stream:
    print(event)
```

# When writing ansible code, you MUST follow these principles

## General

- Use the fully-qualified collection names (fqcn). for example: `ansible.builtin.shell`
