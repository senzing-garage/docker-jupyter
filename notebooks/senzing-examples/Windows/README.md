### Volumes

1. :pencil2: Specify the directory containing the Senzing installation.
   Use the same `SENZING_VOLUME` value used when performing
   "[How to initialize Senzing with Docker](https://github.com/Senzing/knowledge-base/blob/master/HOWTO/initialize-senzing-with-docker.md)".
   Example:

    ```console
    set SENZING_VOLUME=C:\my-senzing
    ```

    1. Here's a simple test to see if `SENZING_VOLUME` is correct.
       The following commands should return file contents.
       Example:

        ```console
        type %SENZING_VOLUME%\g2\g2BuildVersion.json
        type %SENZING_VOLUME%\g2\data\libpostal\data_version
        ```


1. Identify the `data_version`, `etc`, `g2`, and `var` directories.
   Example:

    ```console
    export SENZING_DATA_VERSION_DIR=%SENZING_VOLUME%\data\1.0.0
    export SENZING_ETC_DIR=%SENZING_VOLUME%\etc
    export SENZING_G2_DIR=%SENZING_VOLUME%\g2
    export SENZING_VAR_DIR=%SENZING_VOLUME%\var
    ```
