# Chocolatey Package: Microsoft Office Deployment

[![license](https://img.shields.io/github/license/mashape/apistatus.svg?style=popout-square)](licence) [![Chocolatey](https://img.shields.io/chocolatey/v/microsoft-office-deployment?label=package%20version)](https://chocolatey.org/packages/microsoft-office-deployment) [![Chocolatey](https://img.shields.io/chocolatey/dt/microsoft-office-deployment?label=package%20downloads&style=flat-square)](https://chocolatey.org/packages/microsoft-office-deployment)

## Description

Installiert Microsoft Office 2019 und 365.

## Package Parameters

- `/64bit` to install Office 365 ProPlus 64-bit, otherwise it will default to 32-bit.
- `/DisableUpdate` TRUE, FALSE
- `/Shared` to install with Shared Computer Licensing for Remote Desktop Services.
- `/Channel` [Microsoft Docs](https://docs.microsoft.com/en-us/DeployOffice/overview-of-update-channels-for-office-365-proplus?redirectSourcePath=%252fen-us%252farticle%252f9ccf0f13-28ff-4975-9bd2-7e4ea2fefef4)
- `/Language` default `MatchOS` `MatchOS, ar-sa, bg-bg, zh-cn, zh-tw, hr-hr, cs-cz, da-dk, nl-nl, en-us, et-ee, fi-fi, fr-fr, de-de, el-gr, he-il, hi-in, hu-hu, id-id, it-it, ja-jp, kk-kz, ko-kr, lv-lv, lt-lt, ms-my, nb-no, pl-pl, pt-br, pt-pt, ro-ro, ru-ru, sr-latn-cs, sk-sk, sl-si, es-es, sv-se, th-th, tr-tr, uk-ua, vi-vn`
- `/Product` default `HomeBusinessRetail` Supportet `PersonalRetail, ProPlusRetail, O365SmallBusPremRetail, O365BusinessRetail, O365ProPlusRetail, InfoPathRetail, SPDRetail, ProjectProRetail, VisioProRetail, LyncEntryRetail, LyncRetail, SkypeforBusiness, EntryRetail, SkypeforBusinessRetail, AccessRetail, Access2019Retail, Access2019Volume, ExcelRetail, Excel2019Retail, Excel2019Volume, HomeBusinessRetail, HomeBusiness2019Retail, HomeStudentRetail, HomeStudent2019Retail, O365HomePremRetail, OneNoteRetail, OutlookRetail, Outlook2019Retail, Outlook2019Volume, Personal2019Retail, PowerPointRetail, PowerPoint2019Retail, PowerPoint2019Volume, ProfessionalRetail, Professional2019Retail, ProjectProXVolume, ProjectPro2019Retail, ProjectPro2019Volume, ProjectStdRetail, ProjectStdXVolume, ProjectStd2019Retail, ProjectStd2019Volume, ProPlus2019Volume, PublisherRetail, Publisher2019Retail, Publisher2019Volume, Standard2019Volume, VisioProXVolume, VisioPro2019Retail, VisioPro2019Volume, VisioStdRetail, VisioStdXVolume, VisioStd2019Retail, VisioStd2019Volume, WordRetail, Word2019Retail, Word2019Volume`
- `/Exclude` `Publisher, PowerPoint, OneDrive, Outlook, OneNote, Lync, Groove, Excel, Access, Word`
- `/XMLfile` *Path* Use XML file for confiuguration. Ignores all other parameters.
- `/RemoveMSI` to remove any pre-existing msi installations.
- `/ProofingToolLanguage` Comma separated list of extra proofing tool languages to install.

## Installation

### choco

installation without parameters.

```ps1
 choco install microsoft-office-deployment
```

installation with parameters.

```ps1
 choco install microsoft-office-deployment --params="'/64bit /ProofingToolLanguage:de-de,da-dk,es-es'"
```

### [ITIGO Packages](https://github.com/itigoag/ansible.packages)

installation without parameters.

```yml
packages:
  airtame:
    version: latest
```

installation with parameters.

```yml
packages:
  airtame:
    version: latest
    params: "'/64bit /ProofingToolLanguage:de-de,da-dk,es-es'"
```

## ToDo

- Check if there is a factory preinstalled version on it and uninstall it.
- Generate uninstall.xml based on the specific install.xml

## Disclaimer

These Chocolatey Packages only contain installation routines. The software itself is downloaded from the official sources of the software developer. ITIGO AG has no affilation with the software developer.

## Author

- [Simon Bärlocher](https://sbaerlocher.ch)
- [Open Circle AG](https://www.open-circle.ch)

## License

This project is under the MIT License. See the [LICENSE](LICENSE) file for the full license text.

## Copyright

(c) 2021, Open Circle AG
