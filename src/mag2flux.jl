# This file is a part of AstroLib.jl. License is MIT "Expat".
# Copyright (C) 2016 Mosè Giordano.

"""
    mag2flux(mag[, zero_point, ABwave=number]) -> flux

### Purpose ###

Convert from magnitudes to flux expressed in erg/(s cm² Å).

### Explanation ###

This is the reverse of `flux2mag`.

### Arguments ###

* `mag`: the magnitude to be converted in flux.  It can be either a scalar or an
  array.
* `zero_point`: scalar giving the zero point level of the magnitude.  If not
 supplied then defaults to 21.1 (Code et al 1976).  Ignored if the `ABwave`
 keyword is supplied
* `ABwave` (optional numeric keyword): wavelength, scalar or array, in
 Angstroms.  If supplied, then the input `mag` is assumed to contain Oke AB
 magnitudes (Oke & Gunn 1983, ApJ, 266, 713;
 http://adsabs.harvard.edu/abs/1983ApJ...266..713O).

### Output ###

The flux.  It is of the same type, scalar or array, as `mag`.

If the `ABwave` keyword is set, then the flux is given by the expression

    flux = 10^(-0.4*(mag +2.406 + 4*log10(ABwave)))     

Otherwise the flux is given by

    f =  10^(-0.4*(mag + zero_point))

### Notes ###

Code of this function is based on IDL Astronomy User's Library.
"""
function mag2flux(mag::AbstractFloat, zero_point::AbstractFloat;
                  ABwave::AbstractFloat=NaN)
    if isnan(ABwave)
        return exp10(-0.4*(mag + zero_point))
    else
        return exp10(-0.4*(mag + 2.406 + 5*log10(ABwave)))
    end
end

mag2flux(mag::Real, zero_point::Real=21.1; ABwave::Real=NaN) =
    mag2flux(promote(float(mag), float(zero_point))..., ABwave=float(ABwave))

function mag2flux{N<:Real}(mag::AbstractArray{N}, zero_point::Real=21.1;
                           ABwave::Real=NaN)
    flux = similar(mag, AbstractFloat)
    for i in eachindex(mag)
        flux[i] = mag2flux(mag[i], zero_point, ABwave=ABwave)
    end
    return flux
end