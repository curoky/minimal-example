{ lib
, python3
, fetchFromGitHub
}:

python3.pkgs.buildPythonApplication rec {
  pname = "licenseheaders";
  version = "0.8.8";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "johann-petrak";
    repo = "licenseheaders";
    rev = "v${version}";
    hash = "sha256-JGeIH6rUhXPFqXF2lecjeYKwUD8isW4LLBTFt5FTVsw=";
  };

  nativeBuildInputs = [
    python3.pkgs.setuptools
    python3.pkgs.wheel
  ];
  doCheck = false;

  propagatedBuildInputs = with python3.pkgs; [
    regex
  ];

  pythonImportsCheck = [ "licenseheaders" ];

  meta = with lib; {
    description = "Simple python script to add/replace license headers in a directory tree of source files";
    homepage = "https://github.com/johann-petrak/licenseheaders";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
    mainProgram = "licenseheaders";
  };
}
