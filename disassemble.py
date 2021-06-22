
import sys
import importlib.util
from dis import dis

src_file = sys.argv[1]
module_spec = importlib.util.spec_from_file_location("unknown.module", src_file)
module = importlib.util.module_from_spec(module_spec)
module_spec.loader.exec_module(module)

dis(module)
