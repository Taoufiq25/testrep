# dSPACE_MLBII
Library for the MicroLabBox II from dSPACE

## Library Creation and Binary File Handling with Git 

A custom Simulink library, and Regulators_libraby, was developed in Matlab to provide reusable control components for various simulation projects.

When using Git for version control with Matlab and Simulink project, it is essential to correctly register binary file types to prevent file corruption. This includes common Matlab file formats (e.g., .slx, .mdl, .mat). Without proper registration, third-party source control tools may corrupt files by modifying end-of-line characters or attempting automatic merges.

To ensure correct binary handling, a .gitattributes file was created using the following Matlab command:

#### copyfile(fullfile(matlabroot,'toolbox','shared','cmlink','git','auxiliary_files', ...'mwgitattributes'),fullfile(pwd,'.gitattributes'))

This file regiters common Matlab and binary file extensions eith Git, making them as binary to avoid unwanted transformations during version control operations. 


## Github Continuous Integration Workfolw 

The Regulators_library and its associated .gitattributes file were uploaded to a Github this repository. This setup enables easy reuse of the library across multiple projects by different users.

### 1. Importing the Library

to use the library in a new project:
- Clone the repository in Matlab using the Git integration or the repositiry HTTPS/SSH link.
- Once cloned, the library is immediately available to use in any Simulink model.

### 2. Modifying the Library

Modidications to library components should always be made within the original library file (Regulators_library.slx). Matlab ensures that the components in all projects are automatically synchronized with the library.

To share modifications with all users of the library:
- Commit and push the changes to the Github repository
- Once the repository maintrainer reviews and merges the changes into the main branch, all users pulling from the repository will receive the updated componenets.
- Any project that references the library will reflect these updates, ensuring consistency across development environments. 
