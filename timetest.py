import os
import time
from pathlib import Path


def test(cmd, times, N):
    ts = []
    print(f'{cmd} {N}')
    for _ in range(times):
        start = time.perf_counter()
        os.popen(f'{cmd} {N}').read()
        end = time.perf_counter()
        ts.append(end - start)
    return sum(ts) / times


if __name__ == "__main__":
    if os.name == 'nt':
        cpucmd = "cpu/mul.exe"
        cudacmd = "cuda/mul.exe"
        openmpcmd = "openmp/.exe"  # TODO
    else:
        cpucmd = "cpu/mul"
        cudacmd = "cuda/mul"
        openmpcmd = "openmp/"  # TODO
    
    times = 10
    N = 600
    # N = ''
    s = ''
    # for mode in ['cpu', 'cuda', 'openmp']:
    for mode in ['cpu', 'cuda']:
        meantime = test(Path(locals()[f'{mode}cmd']).resolve(), times, N)
        s +=f"{mode} time: {meantime}\n"
    print(s[:-1])
