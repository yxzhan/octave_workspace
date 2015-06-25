## Copyright (C) 2015 Asma Afzal
##
## This file is part of Octave.
##
## Octave is free software; you can redistribute it and/or modify it
## under the terms of the GNU General Public License as published by
## the Free Software Foundation; either version 3 of the License, or (at
## your option) any later version.
##
## Octave is distributed in the hope that it will be useful, but
## WITHOUT ANY WARRANTY; without even the implied warranty of
## MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
## General Public License for more details.
##
## You should have received a copy of the GNU General Public License
## along with Octave; see the file COPYING.  If not, see
## <http://www.gnu.org/licenses/>.

## -*- texinfo -*-
## @deftypefn  {Function File} {} statget (@var{options}, @var{parname})
## @deftypefnx {Function File} {} statget (@var{options}, @var{parname}, @var{default})
## Return the specific option @var{parname} from the statistics options
## structure @var{options} created by @code{statset}.
##
## If @var{parname} is not defined then return @var{default} if supplied,
## otherwise return an empty matrix.
##
## (This function uses the code of Octaves 'optimget' function.)
## @end deftypefn

function retval = statget (options, parname, default)

  if (nargin < 2 || nargin > 4 || ! isstruct (options) || ! ischar (parname))
    print_usage ();
  endif

  ## Expand partial-length names into full names
  opts = __all_stat_opts__ ();
  
  idx = lookup (tolower (opts), tolower (parname), "m");

  if (idx)
    parname = opts{idx};
  else
    warning ("unrecognized option: %s", parname);
  endif
  if (isfield (options, parname))
    retval = options.(parname);
  elseif (nargin > 2)
    retval = default;
  else
    retval = [];
  endif

endfunction


%!shared opts
%! opts = statset ("tolx", 0.1, "maxit", 100);
%!assert (statget (opts, "TolX"), 0.1)
%!assert (statget (opts, "maxit"), 100)
%!assert (statget (opts, "MaxITer"), 100)
%!assert (statget (opts, "TolFun"), [])
%!assert (statget (opts, "TolFun", 1e-3), 1e-3)

## Test input validation
%!error statget ()
%!error statget (1)
%!error statget (1,2,3,4,5)
%!error statget (1, "name")
%!error statget (struct (), 2)
%!warning <unrecognized option: foobar> (statget (opts, "foobar"));
%!warning <ambiguous option: Max> (statget (opts, "Max"));
