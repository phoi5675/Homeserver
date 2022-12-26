from abc import *


class SetupBase:
    def __init__(self):
        pass

    @abstractmethod
    def run(self):
        pass
