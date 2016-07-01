.. _pkg_tex:

TeX
---

The TeX document processing system.

+------------------+--------------------+
| System           | Package            |
+==================+====================+
| BSD Ports        | print/texlive-full |
+------------------+--------------------+
| Debian/Ubuntu    | texlive-full       |
+------------------+--------------------+
| Fedora           | texlive-2015       |
+------------------+--------------------+
| Homebrew         | N/A*               |
+------------------+--------------------+
| RedHat/CentOS    | N/A†               |
+------------------+--------------------+

\*
  Install TeXLive or MacTeX
†
  Provides an obsolete version; install TeXLive

- `TeXLive website (for Unix) <https://www.tug.org/texlive/>`__
- `TeXLive quick install (for Unix) <https://www.tug.org/texlive/quickinstall.html>`__
- `MacTeX website (for MacOS X) <https://tug.org/mactex/>`__
- `MacTeX download (for MacOS X) <http://mirror.ctan.org/systems/mac/mactex/MacTeX.pkg>`__
- `MikTeX website (for Windows) <http://www.miktex.org/>`__
- `MikTeX download (for Windows) <http://www.miktex.org/download>`__

Local font configuration may be required to make the
TeX Gyre fonts available:

- Linux and FreeBSD: Use the provided :program:`fontconfig` template
  or create your own
- MacOS X: Add to system using :program:`FontBook`
- Windows: May need adding to the system fonts if not found
  automatically
