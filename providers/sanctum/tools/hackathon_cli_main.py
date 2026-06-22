import subprocess
import pathlib
import sys

REPO_ROOT = pathlib.Path(__file__).resolve().parents[1]
SANCTUM_DIR = REPO_ROOT / "providers" / "sanctum"

def main():
    # Very thin wrapper: just run the sanctum scripts
    env = dict(**os.environ)
    env.setdefault("CYGNUS_URL", "http://127.0.0.1:8081")
    env.setdefault("CYGNUS_TOKEN", "3339993387")

    subprocess.check_call(["./gen.sh", "clean"], cwd=SANCTUM_DIR, env=env)
    subprocess.check_call(["./gen.sh", "all"], cwd=SANCTUM_DIR, env=env)
    subprocess.check_call(["./check.sh"], cwd=SANCTUM_DIR, env=env)

if __name__ == "__main__":
    main()


