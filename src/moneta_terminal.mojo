
from cli.cli_interpreter import CLI
from endpoints.server_wrapper import ServerWrapper
from logger_factory.logger_factory import logger_factory

def setup_logging_factory():
    factory = logger_factory()
    factory.set_default_path(os.path.abspath(os.path.join(os.path.abspath(__file__), "..", "..", "logs",)) + "/" )

def start_server():
    # server = ServerWrapper()
    # tcp_server = threading.Thread(target=server.run_server)
    # tcp_server.run()

def start_cli():
    # cli = CLI()
    # cli_loop = threading.Thread(target=cli.MainLoop)
    # cli_loop.run()


fn main() -> None:
    try:
        setup_logging_factory()
        start_cli()
    finally:
        logging.shutdown()
