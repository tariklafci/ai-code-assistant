class Task:
    def __init__(self, param=None):
        # parameters passed in (e.g. {'prompt': ..., 'max_score': ...})
        self.param  = param or {}
        # for storing your outputs (e.g. title, code)
        self.output = {}
        # score placeholder
        self.score  = 0

    def run(self):
        raise NotImplementedError("Override in subclass")

    def calculate_score(self):
        raise NotImplementedError("Override in subclass")
