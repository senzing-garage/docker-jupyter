# Ijava setup

The installation and configuration of the Ijava kernel all come from https://github.com/SpencerPark/IJava. If you would like to go there for instructions then return here for the configuration of the kernel.json, then use the link, otherwise, all required instructions will be posted here. 

### Requirements

- Java JDK >= 9, not the JRE Check your version using the java -version command

- Next ensure that java is in a location where the jdk was installed and not just the jre. Use the ```java --list-modules``` command to do this. The list should contain ```jdk.jshell```. 

```bash
> java --list-modules | grep "jdk.jshell"
```
 
- Ensure that Jupyter notebook is installed on your system

### Setup

1. Download the most recent Ijava zip from the [releases tab](https://github.com/SpencerPark/IJava/releases)
2. Unzip the file to your prefered location, it should have the ```install.py``` script and the ```java``` directory in it.
3. Run the python scrip with the python3 command 

    ```bash
    # Pass the -h option to see the help page
    > python3 install.py -h

    # Otherwise a common install command is
    > python3 install.py --sys-prefix
    ```
    
## Kernel.json configuration

Now that you have the Ijava kernel installed, you will need to configure the kernel.json to setup the environment to work with Senzing.

The environment variables set in the json are similar to the ones set when running the docker image in the README.md

#### kernel.json
:pencil2: Check the java and senzing paths incase they were put in alternative directories. Once you've checked your directories, write the new environment variables into your json.
```
{
    "argv":[
        "/usr/lib/jvm/jre-13/bin/java",
        "-Djava.library-path=/opt/senzing/g2/lib/",
        "-jar",
        "@KERNEL_INSTALL_DIRECTORY@/ijava-1.3.0.jar",
        "{connection_file}"
    ],
    "display_name":"Java",
    "language":"java",
    "interrupt_mode":"message",
    "env": {
        "IJAVA_CLASSPATH":"/opt/senzing/g2/lib/g2.jar",
        "LD_LIBRARY_PATH":"/opt/senzing/g2/lib/",
        "DYLD_LIBRARY_PATH":"/opt/senzing/g2/lib/"
    }
}
```

After editing the kernel.json, you will need to rerun the python script the same way it was ran in step 3 of the setup.
