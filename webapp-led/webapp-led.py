from flask import Flask, render_template, request

app = Flask(__name__)

# File paths for LED states
LED_GREEN_FILE = "/home/ledG"
LED_BLUE_FILE = "/home/ledB"

def read_file(file_path):
    """Read the current value from a file."""
    try:
        with open(file_path, "r") as file:
            return file.read().strip()
    except FileNotFoundError:
        return "0"  # Default value if the file doesn't exist

def write_file(file_path, value):
    """Write a value to a file."""
    with open(file_path, "w") as file:
        file.write(value)

@app.route('/', methods=['GET', 'POST'])
def index():
    message = ""
    if request.method == 'POST':
        if 'led_green' in request.form:
            # Toggle LED Green
            current_value = read_file(LED_GREEN_FILE)
            new_value = "1" if current_value == "0" else "0"
            write_file(LED_GREEN_FILE, new_value)
            message = f"LED Green updated to {new_value}"
        elif 'led_blue' in request.form:
            # Toggle LED Blue
            current_value = read_file(LED_BLUE_FILE)
            new_value = "1" if current_value == "0" else "0"
            write_file(LED_BLUE_FILE, new_value)
            message = f"LED Blue updated to {new_value}"
    return render_template('index.html', message=message)

if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0', port=9900)
