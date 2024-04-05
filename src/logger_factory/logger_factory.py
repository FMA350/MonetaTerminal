import logging
import os
from datetime import datetime

from helper_methods.singleton_meta import SingletonMeta

class logger_factory(metaclass=SingletonMeta) :

    def __init__(self) -> None:
        self.__default_path = "../logs/"
        self.date = str(datetime.now().strftime("%H%M%S"))
        self.formatter = logging.Formatter('%(asctime)s - %(levelname)s %(filename)s:%(lineno)d - %(message)s')
        
    def __create_path(self, path: str) -> None:
        try:
            os.makedirs(path)
        except FileExistsError:
            pass

    def __make_stream_handler(self, name=str, level=logging.INFO) -> logging.StreamHandler:
        sh = logging.StreamHandler()
        sh.set_name(name)
        sh.setLevel(level)
        sh.setFormatter(self.formatter)
        return sh
    
    def __make_file_handler(self, name: str, level=logging.DEBUG , path="") -> logging.FileHandler:
        if path == "":
            path = self.__default_path
        self.__create_path(path)
        log_name = path + name + "_" + self.date + ".log"
        fh = logging.FileHandler(log_name, mode="a")
        fh.set_name(name)
        fh.setLevel(level)
        fh.setFormatter(self.formatter)
        return fh

    def set_default_path(self, path):
        self.__default_path = path

    #default logger gets file(verbose) + stdout(info) logs
    def make_logger(self, name: str, *others) -> logging.Logger:
        logger = logging.getLogger(name)
        logger.setLevel(logging.DEBUG)
        logger.addHandler(self.__make_file_handler(name))
        logger.addHandler(self.__make_stream_handler(name))
        logger.propagate = True
        return logger