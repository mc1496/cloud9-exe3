
#note make space tab tab is not working on all os
##create multi-line usage/help message for makefile
define USAGE
*******************************************************
using make target
to simplify shell-commands related to this project
*****************************************************************
target:
*****************************************************************
setup:				setup python virtual environment
alias:				create alias for working on this project
install:			upgrade pip and install requirements
test:				run test
validate-circleci:	validate circleci-config.yml locally
run-circleci-local:	run circleci locally
lint:				run lint
all:				run all: install lint test
help: 				this help message
*****************************************************************
endef
export USAGE


#get current dir name
#https://stackoverflow.com/questions/18136918/how-to-get-current-relative-directory-of-your-makefile
export CUR_DIR = $(notdir $(shell pwd))


help:
	@echo "$${USAGE}"


setup:
	@python3 -m venv ~/."$${CUR_DIR}"
	
#adding alis in .bashrc for Amazon Linux 2 did not work!
#delete previous alia if exist then add new one in .profile
alias:
	@sed -i "/alias "$${CUR_DIR}"/d" ~/.profile #sed -i "s/alias "$${CUR_DIR}"/#alias "$${CUR_DIR}"/g" ~/.profile
	@echo "alias $${CUR_DIR}='cd $$PWD && source ~/.$${CUR_DIR}/bin/activate'" >> ~/.profile
	@source ~/.profile

install:
	pip install --upgrade pip &&\
		pip install -r requirements.txt

test:
	#python -m pytest -vv --cov=myrepolib tests/*.py
	#python -m pytest --nbval notebook.ipynb

validate-circleci:
	# See https://circleci.com/docs/2.0/local-cli/#processing-a-config
	circleci config process .circleci/config.yml

run-circleci-local:
	# See https://circleci.com/docs/2.0/local-cli/#running-a-job
	# https://support.circleci.com/hc/en-us/articles/7060937560859-How-to-resolve-error-storage-opt-is-supported-only-for-overlay-over-xfs-with-pquota-mount-option-when-running-jobs-locally-with-the-cli
	# https://github.com/CircleCI-Public/circleci-cli/issues/301
	# circleci local execute -v ~/environment/tmp:/repo --job build
	circleci local execute

lint:
	#hadolint demos/flask-sklearn-student-starter/Dockerfile
	#pylint --disable=R,C,W1203 demos/**/**.py
	pylint --disable=R,C,W1203 *.py
	

all: install lint test
