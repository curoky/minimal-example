{ lib,
  python3Packages,
  fetchPypi,
  fetchFromGitHub
}:

python3Packages.buildPythonApplication rec {
  pname = "netron";
  version = "7.9.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "lutzroeder";
    repo = "netron";
    rev = "refs/tags/v${version}";
    hash = "sha256-MeCotrayvWtnTwFHgYzAnl5srfxUTdPVSFvq7Sjf6dM=";
  };

  nativeBuildInputs = with python3Packages; [
    setuptools-scm
  ];

  propagatedBuildInputs = [
  ];

  configurePhase = ''
    python3 package.py build version
    cp -r dist/pypi/netron .
    cp dist/pypi/pyproject.toml .
  '';

  doCheck = false;

  meta = with lib; {
    changelog = "";
    description = "";
    homepage = "";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ moni ];
  };
}
