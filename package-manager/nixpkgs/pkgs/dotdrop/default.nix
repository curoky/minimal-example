{ lib,
  python3Packages,
  fetchFromGitHub
}:

python3Packages.buildPythonApplication rec {
  pname = "dotdrop";
  version = "1.14.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "deadc0de6";
    repo = "dotdrop";
    rev = "v${version}";
    hash = "sha256-K0STUs6RkuFoshxnhWCGaITAAbQtO/MQT5o49HKZlwQ=";
  };

  nativeBuildInputs = with python3Packages; [
    setuptools
    wheel
  ];

  propagatedBuildInputs = with python3Packages; [
    distro
    docopt
    jinja2
    packaging
    python-magic
    requests
    ruamel-yaml
    tomli
    tomli-w
  ];

  pythonImportsCheck = [ "dotdrop" ];

  meta = with lib; {
    description = "Save your dotfiles once, deploy them everywhere";
    homepage = "https://github.com/deadc0de6/dotdrop";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ ];
    mainProgram = "dotdrop";
  };
}
