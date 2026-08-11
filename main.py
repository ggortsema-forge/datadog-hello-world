from ddtrace import tracer


def main():
    with tracer.trace("say-hello", service="hello-world"):
        print("Hello Datadog!")


if __name__ == "__main__":
    main()
