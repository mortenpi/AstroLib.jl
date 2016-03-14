# This file is a part of AstroLib.jl. License is MIT "Expat".
# Copyright (C) 2016 Mosè Giordano.

"""
    airtovac(wave_air) -> Float64

### Purpose ###

Converts air wavelengths to vacuum wavelengths.

### Explanation ###

Wavelengths are corrected for the index of refraction of air under standard
conditions.  Wavelength values below 2000 Å will not be altered.  Uses relation
of Ciddor (1996).

### Arguments ###

* `wave_air`: can be either a scalar or an array of numbers.  Wavelengths are
corrected for the index of refraction of air under standard conditions.
Wavelength values below 2000 Å will *not* be altered, take care within [1 Å,
2000 Å].

### Output ###

Vacuum wavelength in angstroms, same number of elements as `wave_air`.

### Method ###

Uses relation of Ciddor (1996), Applied Optics 62, 958
(http://adsabs.harvard.edu/abs/1996ApOpt..35.1566C).

### Example ###

If the air wavelength is `w = 6056.125` (a Krypton line), then `airtovac(w)`
yields an vacuum wavelength of `6057.8019`.

### Notes ###
Code of this function is based on IDL Astronomy User's Library.
"""
function airtovac(wave_air::Number)
    wave_vac = convert(Float64, wave_air)
    if wave_vac >= 2000.0
        for iter= 1:2
            sigma2 = (1e4/wave_vac)^2.0 # Convert to wavenumber squared
            # Computer conversion factor.
            fact = 1.0 + 5.792105e-2/(238.0185e0 - sigma2) +
                1.67917e-3/(57.362e0 - sigma2)
            wave_vac = wave_air*fact # Convert Wavelength
        end
    end
    return wave_vac
end
@vectorize_1arg Number airtovac