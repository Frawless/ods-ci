*** Settings ***
Resource         ../../Resources/ODS.robot
Resource         ../../Resources/Common.robot
Resource         ../../Resources/Page/ODH/JupyterHub/JupyterHubSpawner.robot
Resource         ../../Resources/Page/ODH/JupyterHub/JupyterLabLauncher.robot
Library          DebugLibrary
Library          JupyterLibrary
Suite Setup      Begin Web Test
Suite Teardown   End Web Test

*** Variables ***


*** Test Cases ***
Minimal Tensorflow test
  [Tags]  Regression
  ...     PLACEHOLDER  #Category tags
  ...     PLACEHOLDER  #Polarion tags
  Wait for RHODS Dashboard to Load
  Launch JupyterHub From RHODS Dashboard Dropdown
  Login To Jupyterhub  ${TEST_USER.USERNAME}  ${TEST_USER.PASSWORD}  ${TEST_USER.AUTH_TYPE}
  ${authorization_required} =  Is Service Account Authorization Required
  Run Keyword If  ${authorization_required}  Authorize jupyterhub service account
  Wait Until Page Contains Element  xpath://span[@id='jupyterhub-logo']
  Fix Spawner Status
  # Size needs to change
  Spawn Notebook With Arguments  image=tensorflow  size=Default
  Wait for JupyterLab Splash Screen  timeout=30
  Maybe Select Kernel
  ${is_launcher_selected} =  Run Keyword And Return Status  JupyterLab Launcher Tab Is Selected
  Run Keyword If  not ${is_launcher_selected}  Open JupyterLab Launcher
  Launch a new JupyterLab Document  kernel=Python 3 (ipykernel)
  #Launch a new JupyterLab Document
  Close Other JupyterLab Tabs
  Sleep  5
  Run Cell And Check Output  !python --version  Python 3.8.6
  #Run Cell And Check Output  !python --version  Python 3.8.7
  Run Cell And Check Output  !nvcc --version | grep nvcc:  nvcc: NVIDIA (R) Cuda compiler driver
  Run Cell And Check Output  !nvcc --version | grep "Cuda compilation"  Cuda compilation tools, release 11.0, V11.0.221
  Run Cell And Check Output  !pip show tensorflow-gpu | grep Version:  Version: 2.4.1

Failing Test Case (CUDA warnings)
  Run Repo and Clean  https://github.com/lugi0/notebook-benchmarks  notebook-benchmarks/tensorflow/GPU-with-warnings.ipynb 
  Capture Page Screenshot
  JupyterLab Code Cell Error Output Should Not Be Visible

Passing Test Case (GPU)
  Run Repo and Clean  https://github.com/lugi0/notebook-benchmarks  notebook-benchmarks/tensorflow/GPU-no-warnings.ipynb 
  Capture Page Screenshot
  JupyterLab Code Cell Error Output Should Not Be Visible

Failing Test Case (CPU + Tensorflow warnings)
  Run Repo and Clean  https://github.com/lugi0/notebook-benchmarks  notebook-benchmarks/tensorflow/tensorflow-cpu_no-warnings.ipynb  
  Capture Page Screenshot
  JupyterLab Code Cell Error Output Should Not Be Visible