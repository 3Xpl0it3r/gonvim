import os

import pynvim
from pynvim.api.nvim import Nvim
import json


@pynvim.plugin
class Json(object):
    def __init__(self, nvim: Nvim):
        self.nvim = nvim

    # load json from file
    # usage vim.fn.JsonLoadF(filename)
    @pynvim.function(name="JsonLoadF", sync=True)
    def load_from_file(self, args):
        file_name = args[0]
        with open(file_name) as fp:
            raw = fp.read()
            if len(raw) == 0 or raw == "" or raw is None:
                return None
            return json.loads(raw)

    @pynvim.function(name="JsonLoadS", sync=True)
    def load_from_string(self, args):
        input_str = args[0]
        return json.loads(input_str)

    @pynvim.function(name="JsonDumpF", sync=True)
    def dump_to_file(self, args):
        file_name = args[0]
        data = args[1]
        with open(file_name, "w", encoding="utf8") as writer:
            json.dump(data, writer)
