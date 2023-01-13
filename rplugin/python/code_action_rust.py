import os

import pynvim
from pynvim.api.nvim import Nvim
from urllib.request import urlopen
from urllib.error import HTTPError, URLError
import json
import subprocess


@pynvim.plugin
class CodeActionsRust(object):
    def __init__(self, nvim: Nvim):
        self.nvim = nvim
        self.crate_search_api = "https://crates.io/api/v1/crates?page=1&per_page=20&q={}"
        self.crate_query_api = "https://crates.io/api/v1/crates/{}"

    @pynvim.function(name="CrateSearch", sync=True)
    def api_crate_search(self, crate_name):
        try:
            response = urlopen(self.crate_search_api.format(crate_name), timeout=20).read().decode("utf-8")
            json_data = json.loads(response)
        except Exception as error:
            return None
        return [_["id"] for _ in json_data["crates"]]

    @pynvim.function(name="CrateQuery", sync=True)
    def api_crate_query(self, crate_name):
        try:
            response = urlopen(self.crate_query_api.format(crate_name), timeout=20).read().decode("utf-8")
            json_data = json.loads(response)
        except HTTPError as error:
            return None
        return [{"version": _["num"], "features": " ".join(_["features"])} for _ in json_data["versions"]]


