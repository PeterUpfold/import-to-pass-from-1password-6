#!/usr/bin/env pwsh
#
# 1Password importer in PWSH -- run on a 1Password 6 .txt tab-delimited file
#
# Copyright (C) 2022 Peter Upfold.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
#
[CmdletBinding()]
param($File)

$csv = Import-Csv $File -Delimiter "`t"

$count = $csv | Measure-Object
$count = $count.Count
$i = 0

foreach($line in $csv) {
    #Write-Host $line.Title 
    Write-Progress -Activity Importing -Status "Importing $($line.Title)" -PercentComplete (($i / $count) * 100)

    if ($line.Title.Length -lt 1) {
        $i += 1
        continue
    }

    # determine what fields exist and what fields to throw in the pass entry
    $passEntry = ""

    $passEntry += "$($line.password)`n`n"
    $passEntry += "URL: $($line.URL)`nUsername: $($line.Username)`n`n----------------------`n"

    $allFields = @()

    # fields:
    foreach($member in $line.psobject.Members) {
        $memberName = $member.Name

        if ($member.GetType() -ne [System.Management.Automation.PSNoteProperty]) {
            #Write-Host "Skipping $memberName"
            continue
        }

        if ($line.$memberName.Length -gt 0) {
            # this member exists, add it
            $passEntry += "$($memberName): $($line.$memberName)`n"
        }
    }

    # The problem with adding JSON as below is that all fields, even with zero length data, are included,
    # making the CLI output scroll away -- suddenly the fields you probably need are at the top and are
    # inconvenient to copy/paste.
    #$passEntry += ($line | ConvertTo-Json) + "`n"
    
    # run pass insert -m 
    $passEntry | pass insert -f -m "$($line.Title)" | Out-Null
    if ($LastExitCode -ne 0) {
        Write-Warning "Failed on $($line.Title)"
    }

    $i += 1
}