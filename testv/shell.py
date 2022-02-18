import jamal

while True:
    text = input('$ ')
    if text == "#":
        break
    result, error = jamal.run('<stdin>', text)
    if error:
        print(error.as_string())
    else:
        print(result)
