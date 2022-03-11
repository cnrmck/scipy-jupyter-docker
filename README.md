# scipy-jupyter-docker

## Description
This is a tool for running a scipy notebook on jupyter in a docker container

## Usage
Do NOT store anything in the `/work/` or root (`/`) directory. If you do it will be deleted when you update your container. Only store things in the `/host/` directory.

## Requirements

On Mac requires: 
- python3
- docker
- [ag - the silver searcher](https://github.com/ggreer/the_silver_searcher) (faster grep)

If you're on Windows you'll have to buy a new computer.

Install Ag with: 
```
brew install the_silver_searcher
```

This next command will run the notebook. You can inspect the (terrible) bash code to make sure it's not doing anything weird before you run it.
```
chmod gu+x ./run_scipy_notebook.sh
./run_scipy_notebook.sh 
```

If it succeeds you should see it end with: 
```
To access the server, open this file in a browser:
    file:///home/jovyan/.local/share/jupyter/runtime/jpserver-7-open.html
Or copy and paste one of these URLs:
    http://a66b9b5c8811:8888/lab?token=629c82824e7c45ce48fb7ee1a8648f1b38153f38560fc431
 or http://127.0.0.1:8888/lab?token=629c82824e7c45ce48fb7ee1a8648f1b38153f38560fc431
```

On Mac, grab that final link (the one that starts with `http://127.0.0.1:888...` and paste it into your browser.

## To Add Your Own Packages
To add your own packages, go to `./scipy/Dockerfile` where you should see some RUN statements. You can edit the `conda` and `pip` installs there. 