# scipy-jupyter-docker

This is where you'll put all your files so that they're on your local machine. 

Do NOT store anything in the `/work/` or root (`/`) directory. If you do it will be deleted when you update your container. Only store things in the `/host/` directory.

```
chmod gu+x ./run_scipy_notebook.sh
./run_scipy_notebook.sh 
```

This will run the notebook. You can inspect the (terrible) bash code to make sure it's not doing anything weird.

If it succeeds you should see it end with: 
```
To access the server, open this file in a browser:
    file:///home/jovyan/.local/share/jupyter/runtime/jpserver-7-open.html
Or copy and paste one of these URLs:
    http://a66b9b5c8811:8888/lab?token=629c82824e7c45ce48fb7ee1a8648f1b38153f38560fc431
 or http://127.0.0.1:8888/lab?token=629c82824e7c45ce48fb7ee1a8648f1b38153f38560fc431
```

On Mac, grab that final link (the one that starts with `http://127.0.0.1:888...` and paste it into your browser.