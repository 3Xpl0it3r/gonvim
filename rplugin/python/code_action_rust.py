import os

import pynvim
from pynvim.api.nvim import Nvim
from urllib.request import urlopen
from urllib.error import HTTPError, URLError
import json
from pathlib import Path



@pynvim.plugin
class CodeActionsRust(object):
    def __init__(self, nvim: Nvim):
        self.nvim = nvim
        self.crate_search_api = "https://crates.io/api/v1/crates?page=1&per_page=20&q={}"
        self.crate_query_api = "https://crates.io/api/v1/crates/{}"
        self.cache_dir = os.path.join(Path.home(), ".config/nvim/rplugin/python/cache/crate")

    @pynvim.function(name="CrateSearch", sync=True)
    def api_crate_search(self, args):
        crate_name = args[0]
        cache_file = os.path.join(self.cache_dir,"{}.json".format(crate_name))
        if os.path.exists(cache_file):
            return [crate_name]
        try:
            response = urlopen(self.crate_search_api.format(crate_name), timeout=20).read().decode("utf-8")
            json_data = json.loads(response)
        except Exception as error:
            return None
        # cache to files to speed query
        return [_["id"] for _ in json_data["crates"]]

    @pynvim.function(name="CrateQuery", sync=True)
    def api_crate_query(self, args):
        crate_name = args[0]
        cache_file = os.path.join(self.cache_dir, "{}.json".format(crate_name))
        if os.path.exists(cache_file):
            return self.cache_crate_db(crate_name)
        try:
            response = urlopen(self.crate_query_api.format(crate_name), timeout=20).read().decode("utf-8")
            json_data = json.loads(response)
        except HTTPError as error:
            return None
        with open(cache_file, "w+") as cache_fp:
            json.dump(json_data, cache_fp)
        return [{"version": _["num"], "features": " ".join(_["features"])} for _ in json_data["versions"]]

    def cache_crate_db(self, crate_name):
        cache_file = os.path.join(self.cache_dir, crate_name)
        with open(cache_file, "r") as fp:
            json_data = json.load(fp)
        return [{"version": _["num"], "features": " ".join(_["features"])} for _ in json_data["versions"]]


