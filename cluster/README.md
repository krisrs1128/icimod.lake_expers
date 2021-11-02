
To launch training jobs on the cluster, you can use,

```
condor_submit train.submit executable=sentinel_unet_train.sh
condor_submit train.submit executable=sentinel_unet-historical_train.sh
condor_submit train.submit executable=bing_unet_train.sh
condor_submit train.submit executable=bing_unet-historical_train.sh
condor_submit train.submit executable=sentinel_delse_train.sh
condor_submit train.submit executable=sentinel_delse-historical_train.sh
condor_submit train.submit executable=bing_delse_train.sh
condor_submit train.submit executable=bing_delse-historical_train.sh
```

For inference, first make sure the trained model `pth` object is in
`/staging/ksankaran/lakes/trained_models/`. Then, run

```
condor_submit inference.submit executable=sentinel_unet_inference.sh
condor_submit inference.submit executable=sentinel_unet-historical_inference.sh
condor_submit inference.submit executable=bing_unet_inference.sh
condor_submit inference.submit executable=bing_unet-historical_inference.sh
condor_submit inference.submit executable=sentinel_delse_inference.sh
condor_submit inference.submit executable=sentinel_delse-historical_inference.sh
condor_submit inference.submit executable=bing_delse_inference.sh
condor_submit inference.submit executable=bing_delse-historical_inference.sh
condor_submit inference.submit executable=sentinel_snake_inference.sh
condor_submit inference.submit executable=bing_snake_inference.sh
```

To evaluate different GPU resources, you can use commands like,

```
condor_status -compact -constraint 'TotalGpus > 0' -constraint 'CUDACapability > 6' -constraint 'CUDAGlobalMemoryMb > 12000'
```
