# MCP datatypes

Taken from ChatGPT

When developing an **MCP (Modular Component Protocol)** server — assuming you are referring to the **OpenAI's tool-calling interface via the API**, also known as **"function calling"** or **"tool use"** in the context of GPT models — the arguments to tool calls are defined using **JSON Schema**.

This means the supported data types for the arguments are based on **JSON Schema** standards.

---

### ✅ Supported Data Types

You can use the following **basic JSON Schema types** when defining tool parameters:

| JSON Schema Type | Description                        | Example              |
| ---------------- | ---------------------------------- | -------------------- |
| `string`         | A sequence of characters           | `"hello"`            |
| `number`         | A number (integer or float)        | `3.14`               |
| `integer`        | A whole number                     | `42`                 |
| `boolean`        | A true/false value                 | `true`, `false`      |
| `array`          | A list of values                   | `[1, 2, 3]`          |
| `object`         | A key-value map (nested structure) | `{ "x": 1, "y": 2 }` |
| `null`           | A null value (not commonly used)   | `null`               |

---

### 🔁 Common Schema Constructs

You can also use common JSON Schema features like:

* `enum` – Restrict a value to a fixed set of strings or numbers

  ```json
  { "type": "string", "enum": ["low", "medium", "high"] }
  ```

* `default` – Provide a default value

  ```json
  { "type": "string", "default": "en" }
  ```

* `required` – Specify required fields inside objects

* `items` – Define types of items in arrays

  ```json
  {
    "type": "array",
    "items": { "type": "string" }
  }
  ```

* `properties` – Define fields of an object

---

### 🧠 GPT Understanding and Usage

When GPT is invoking your tool (function), it uses its internal understanding of your schema to fill in the appropriate values. So:

* **Nested structures (objects within objects)** are supported
* **Arrays of objects or primitives** are supported
* The model will respect `enum`, `required`, etc., to shape its tool call

---

### Example Tool Definition

Here’s a full example of a tool definition with all supported types:

```json
{
  "name": "create_event",
  "description": "Creates a calendar event",
  "parameters": {
    "type": "object",
    "properties": {
      "title": { "type": "string" },
      "start_time": { "type": "string", "format": "date-time" },
      "duration_minutes": { "type": "integer" },
      "is_virtual": { "type": "boolean", "default": true },
      "attendees": {
        "type": "array",
        "items": { "type": "string" }
      },
      "location": {
        "type": "object",
        "properties": {
          "address": { "type": "string" },
          "room": { "type": "string" }
        },
        "required": ["address"]
      }
    },
    "required": ["title", "start_time"]
  }
}
```

---

### ❗ Not Supported

* Non-JSON-native types (like `Date` objects, binary blobs, etc.)
* Custom types not serializable to JSON
* Circular references in object schemas

---

If you’re developing this in a specific language or framework (e.g., Python with FastAPI, Node.js, etc.), I can help you generate valid schemas for those environments too.

Would you like help generating or validating a specific schema for your MCP server?

In the **MCP / tool calling interface** (based on **JSON Schema**), when you define a `string` type, you can optionally provide a **`format`** to specify that the string must follow a certain structure.

These formats are **advisory** for the AI model (like GPT-4), and they help guide the model to produce strings in the expected format. However, enforcement depends on your backend validation — the model won't strictly enforce formats but will try to follow them when making tool calls.

---

### ✅ Commonly Supported `format` Values for Strings

Here are the formats officially defined in JSON Schema (and recognized by OpenAI’s API for tool calls):

| Format      | Description                                                 |
| ----------- | ----------------------------------------------------------- |
| `date`      | Full date only (YYYY-MM-DD)                                 |
| `time`      | Time only (HH:MM:SS)                                        |
| `date-time` | Full date + time with timezone (ISO 8601)                   |
| `email`     | Email address                                               |
| `uri`       | A valid URI (e.g., `https://example.com`)                   |
| `hostname`  | A valid domain name                                         |
| `ipv4`      | IPv4 address (e.g., `192.168.0.1`)                          |
| `ipv6`      | IPv6 address                                                |
| `uuid`      | A UUID (e.g., `550e8400-e29b-41d4-a716-446655440000`)       |
| `regex`     | A regular expression pattern string (JavaScript-flavor)     |
| `binary`    | Binary data (rarely used; not well supported in tool calls) |
| `password`  | A password (not validated for strength; mostly a UI hint)   |

---

### 🧠 Practical Use in Tool Calling

In the context of GPT tool calls:

* `date`, `time`, `date-time` are very useful for scheduling, calendar tools, etc.
* `email`, `uri`, `uuid` are helpful for contact info or linking entities.
* GPT is quite good at generating ISO 8601 datetime strings when `format: date-time` is used.

Example:

```json
{
  "type": "string",
  "format": "date-time",
  "description": "Start time of the meeting in ISO 8601 format"
}
```

GPT might produce: `"2025-09-25T15:00:00Z"`

---

### ❗ Custom Formats

OpenAI’s tool calling does **not** currently support custom `format` values beyond the standard JSON Schema ones. If you specify something like:

```json
{ "type": "string", "format": "phone-number" }
```

…it will **not be enforced or recognized** unless your server does custom validation. GPT may still guess what you mean, but it’s not guaranteed.

---

### 🔍 Summary

Supported `string` formats in tool calls (as per JSON Schema):

* `"date"`
* `"time"`
* `"date-time"`
* `"email"`
* `"uri"`
* `"hostname"`
* `"ipv4"`
* `"ipv6"`
* `"uuid"`
* `"regex"`
* `"binary"` (not useful in GPT context)
* `"password"` (UI hint only)

If you want help building a schema with these or testing how GPT responds to them, I can help with examples.

Great question — and the correct answer is:

### ✅ It's called **`pattern`**, not `regex`.

In **JSON Schema** (which OpenAI’s tool calling is based on), the keyword for specifying a regular expression for a string is:

```json
"pattern": "<your-regular-expression>"
```

There is **no** official `"regex"` format. If you use `"format": "regex"`, it will **not** define a regex constraint — it would just mean the string *represents* a regex (e.g., a pattern string like `^\w+$`), not that it *is validated by* one.

---

### ✅ Correct Example:

```json
{
  "type": "string",
  "pattern": "^[A-Z]{3}\\d{3}$",
  "description": "Product code in the format AAA123"
}
```

---

### ❌ Incorrect:

```json
{
  "type": "string",
  "format": "regex"  // This does NOT enforce a regex pattern
}
```

That would be interpreted as "this string represents a regular expression", not that it should be validated against one.

---

### Summary

| Purpose                          | JSON Schema Keyword                       |
| -------------------------------- | ----------------------------------------- |
| Validate a string with a regex   | ✅ `pattern`                               |
| Indicate the string *is* a regex | 🟡 `format: "regex"` (not for validation) |

So for tool calling schemas:
✅ Use `"pattern"` to apply regex-based validation or hints to the model.

Let me know if you’d like help writing a specific regex for your use case.
