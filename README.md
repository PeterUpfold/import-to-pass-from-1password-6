# Import to Pass from 1Password 6 .txt (TSV) export

This script is a work-in-progress of importing into [Pass](https://www.passwordstore.org/) from a 1Password 6 (for Mac) text-separated values (TSV) file export (using the .txt extension).

This is experimental and should not be relied upon -- it _should_ pull across all the fields in the export, but you are at your own risk. Don't delete your source data!

Make sure to tidy up properly (e.g. `shred -u`) unencrypted copies of your export. I recommend working with these files on a `tmpfs` to avoid unnecessary saving of unencrypted password data on disk.

This currently does not handle the data structure in a particuarly formalised manner -- perhaps in the future this needs to dump the fields into the `pass` destination files in JSON?

## Why PowerShell?

I don't know if it is just my 1Password database, but I had issues with other languages CSV/TSV parsing of my exports. PowerShell's `Import-Csv` seemed to be quite tolerant of the "weirdness". Also, I like PowerShell, and I'm delighted it's on more platforms than just Windows.

## Usage

    pwsh import-to-pass-from-1password-6.ps1 -File /tmp/yourexport.txt

## Licence
    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at
    
        http://www.apache.org/licenses/LICENSE-2.0
    
    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.

