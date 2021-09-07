
To launch training jobs on the cluster, you can use,

```
condor_submit train.submit --executable=bing_unet_train.sh
condor_submit train.submit --executable=bing_delse_train.sh
condor_submit train.submit --executable=sentinel_unet_train.sh
condor_submit train.submit --executable=sentinel_delse_train.sh
```

For inference, first make sure the trained model `pth` object is in
`/staging/ksankaran/lakes`. Then, run

```
condor_submit inference.submit --executable=bing_unet_inference.sh
condor_submit inference.submit --executable=bing_delse_inference.sh
condor_submit inference.submit --executable=sentinel_unet_inference.sh
condor_submit inference.submit --executable=sentinel_delse_inference.sh
```
