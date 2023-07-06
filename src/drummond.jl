# Rational approximations to generalized hypergeometric functions
# using Drummond's sequence transformation

# ₀F₀(;z)
function pFqdrummond(::Tuple{}, ::Tuple{}, z::T; kmax::Int = KMAX) where T
    if norm(z) < eps(real(T))
        return one(T)
    end
    μlo = one(z)
    μhi = inv(2-z)
    Tlo = one(z)
    Thi = Tlo + 2z*μhi
    μhi, μlo = inv(3-z + z*μhi), μhi
    Thi, Tlo = ((3-z)*Thi + z*(Tlo+z)*μlo)*μhi, Thi
    k = 2
    while k < kmax && errcheck(Tlo, Thi, 8eps(real(T)))
        μhi, μlo = inv(k+2-z + k*z*μhi), μhi
        Thi, Tlo = ((k+2-z)*Thi + k*z*Tlo*μlo)*μhi, Thi
        k += 1
    end
    k < kmax || @warn "Rational approximation to "*pFq2string(Val{0}(), Val{0}())*" reached the maximum type of ("*string(kmax, ", ", kmax)*")."
    return isfinite(Thi) ? Thi : Tlo
end

# ₁F₀(α;z)
function pFqdrummond(α::Tuple{T1}, ::Tuple{}, z::T2; kmax::Int = KMAX) where {T1, T2}
    α = α[1]
    T = promote_type(T1, T2)
    absα = abs(T(α))
    if norm(z) < eps(real(T)) || norm(α) < eps(absα)
        return one(T)
    end
    ζ = inv(z)
    Nlo = ζ/α
    Dlo = ζ/α
    Tlo = Nlo/Dlo
    Nhi = (2ζ - (α+1))*Nlo + 2ζ
    Dhi = (2ζ - (α+1))*Dlo
    Thi = Nhi/Dhi
    if norm(α+1) < eps(absα+1)
        return Thi
    end
    Nhi /= α+1
    Dhi /= α+1
    Nhi, Nlo = (3ζ-(α+3))*Nhi + (ζ-1)*Nlo + ζ, Nhi
    Dhi, Dlo = (3ζ-(α+3))*Dhi + (ζ-1)*Dlo, Dhi
    Thi, Tlo = Nhi/Dhi, Thi
    if norm(α+2) < eps(absα+2)
        return Thi
    end
    Nhi /= α+2
    Dhi /= α+2
    k = 2
    while k < kmax && errcheck(Tlo, Thi, 8eps(real(T)))
        Nhi, Nlo = ((k+2)*ζ-(α+2k+1))*Nhi + k*(ζ-1)*Nlo, Nhi
        Dhi, Dlo = ((k+2)*ζ-(α+2k+1))*Dhi + k*(ζ-1)*Dlo, Dhi
        Thi, Tlo = Nhi/Dhi, Thi
        if norm(α+k+1) < eps(absα+k+1)
            return Thi
        end
        Nhi /= α+k+1
        Dhi /= α+k+1
        k += 1
    end
    k < kmax || @warn "Rational approximation to "*pFq2string(Val{1}(), Val{0}())*" reached the maximum type of ("*string(kmax, ", ", kmax)*")."
    return isfinite(Thi) ? Thi : Tlo
end

# ₀F₁(β;z)
function pFqdrummond(::Tuple{}, β::Tuple{T1}, z::T2; kmax::Int = KMAX) where {T1, T2}
    β = β[1]
    T = promote_type(T1, T2)
    if norm(z) < eps(real(T))
        return one(T)
    end
    ζ = inv(z)
    Nlo = β*ζ
    Dlo = β*ζ
    Tlo = Nlo/Dlo
    Nmid = ((β+1)*(2)*ζ - 1)*Nlo + (β+1)*(2)*ζ
    Dmid = ((β+1)*(2)*ζ - 1)*Dlo
    Tmid = Nmid/Dmid
    Nhi = ((β+2)*(3)*ζ - 1)*Nmid + (β+4)*ζ*Nlo + (β+4)*ζ
    Dhi = ((β+2)*(3)*ζ - 1)*Dmid + (β+4)*ζ*Dlo
    Thi = Nhi/Dhi
    k = 2
    Nhi, Nmid, Nlo = ((β+k+1)*(k+2)*ζ-1)*Nhi + k*(β+2k+2)*ζ*Nmid + k*(k-1)*ζ*Nlo + 2ζ, Nhi, Nmid
    Dhi, Dmid, Dlo = ((β+k+1)*(k+2)*ζ-1)*Dhi + k*(β+2k+2)*ζ*Dmid + k*(k-1)*ζ*Dlo, Dhi, Dmid
    Thi, Tmid, Tlo = Nhi/Dhi, Thi, Tmid
    k += 1
    while k < kmax && errcheck(Tmid, Thi, 8eps(real(T)))
        Nhi, Nmid, Nlo = ((β+k+1)*(k+2)*ζ-1)*Nhi + k*(β+2k+2)*ζ*Nmid + k*(k-1)*ζ*Nlo, Nhi, Nmid
        Dhi, Dmid, Dlo = ((β+k+1)*(k+2)*ζ-1)*Dhi + k*(β+2k+2)*ζ*Dmid + k*(k-1)*ζ*Dlo, Dhi, Dmid
        Thi, Tmid, Tlo = Nhi/Dhi, Thi, Tmid
        k += 1
    end
    k < kmax || @warn "Rational approximation to "*pFq2string(Val{0}(), Val{1}())*" reached the maximum type of ("*string(kmax, ", ", kmax)*")."
    return isfinite(Thi) ? Thi : isfinite(Tmid) ? Tmid : Tlo
end

# ₂F₀(α,β;z)
function pFqdrummond(α::Tuple{T1, T1}, ::Tuple{}, z::T2; kmax::Int = KMAX) where {T1, T2}
    (α, β) = α
    T = promote_type(T1, T2)
    absα = abs(T(α))
    absβ = abs(T(β))
    if norm(z) < eps(real(T)) || norm(α*β) < eps(absα*absβ)
        return one(T)
    end
    μlo = T(α*β)
    Tlo = one(T)
    μmid = inv(2-(α+1)*(β+1)*z)
    Tmid = Tlo + 2z*μmid*μlo
    if norm((α+1)*(β+1)) < eps((absα+1)*(absβ+1))
        return Tmid
    end
    μmid *= (α+1)*(β+1)
    μhi = inv((3-((α+2)*(β+2)+(α+β+3))*z) + (1-(α+β+3)*z)*z*μmid)
    Thi = ((3-((α+2)*(β+2)+(α+β+3))*z)*Tmid + ((1-(α+β+3)*z)*Tlo + z*μlo)*z*μmid)*μhi
    if norm((α+2)*(β+2)) < eps((absα+2)*(absβ+2))
        return Thi
    end
    μhi *= (α+2)*(β+2)
    k = 2
    z2 = z*z
    while k < 3 || (k < kmax && errcheck(Tmid, Thi, 8eps(real(T))))
        μhi, μmid, μlo = inv((k+2)-((α+k+1)*(β+k+1)+k*(α+β+2k+1))*z + k*((1-(α+β+3k)*z) - (k-1)*z2*μmid)*z*μhi), μhi, μmid
        Thi, Tmid, Tlo = (((k+2)-((α+k+1)*(β+k+1)+k*(α+β+2k+1))*z)*Thi + k*((1-(α+β+3k)*z)*Tmid - (k-1)*z2*Tlo*μlo)*z*μmid)*μhi, Thi, Tmid
        if norm((α+k+1)*(β+k+1)) < eps((absα+k+1)*(absβ+k+1))
            return Thi
        end
        μhi *= (α+k+1)*(β+k+1)
        k += 1
    end
    k < kmax || @warn "Rational approximation to "*pFq2string(Val{2}(), Val{0}())*" reached the maximum type of ("*string(kmax, ", ", kmax)*")."
    return isfinite(Thi) ? Thi : isfinite(Tmid) ? Tmid : Tlo
end

# ₁F₁(α,β;z)
function pFqdrummond(α::Tuple{T1}, β::Tuple{T2}, z::T3; kmax::Int = KMAX) where {T1, T2, T3}
    α = α[1]
    β = β[1]
    T = promote_type(T1, T2, T3)
    absα = abs(T(α))
    if norm(z) < eps(real(T)) || norm(α) < eps(absα)
        return one(T)
    end
    ζ = inv(z)
    Nlo = β*ζ/α
    Dlo = β*ζ/α
    Tlo = Nlo/Dlo
    Nmid = ((β+1)*(2)*ζ - (α+1))*Nlo + (β+1)*(2)*ζ
    Dmid = ((β+1)*(2)*ζ - (α+1))*Dlo
    Tmid = Nmid/Dmid
    if norm(α+1) < eps(absα+1)
        return Tmid
    end
    Nmid /= α+1
    Dmid /= α+1
    Nhi = ((β+2)*(3)*ζ - (α+3))*Nmid + ((β+4)*ζ-1)*Nlo + (β+4)*ζ
    Dhi = ((β+2)*(3)*ζ - (α+3))*Dmid + ((β+4)*ζ-1)*Dlo
    Thi = Nhi/Dhi
    if norm(α+2) < eps(absα+2)
        return Thi
    end
    Nhi /= α+2
    Dhi /= α+2
    k = 2
    Nhi, Nmid, Nlo = ((β+k+1)*(k+2)*ζ-(α+2k+1))*Nhi + k*((β+2k+2)*ζ-1)*Nmid + k*(k-1)*ζ*Nlo + 2ζ, Nhi, Nmid
    Dhi, Dmid, Dlo = ((β+k+1)*(k+2)*ζ-(α+2k+1))*Dhi + k*((β+2k+2)*ζ-1)*Dmid + k*(k-1)*ζ*Dlo, Dhi, Dmid
    Thi, Tmid, Tlo = Nhi/Dhi, Thi, Tmid
    if norm(α+k+1) < eps(absα+k+1)
        return Thi
    end
    Nhi /= α+k+1
    Dhi /= α+k+1
    k += 1
    while k < kmax && errcheck(Tmid, Thi, 8eps(real(T)))
        Nhi, Nmid, Nlo = ((β+k+1)*(k+2)*ζ-(α+2k+1))*Nhi + k*((β+2k+2)*ζ-1)*Nmid + k*(k-1)*ζ*Nlo, Nhi, Nmid
        Dhi, Dmid, Dlo = ((β+k+1)*(k+2)*ζ-(α+2k+1))*Dhi + k*((β+2k+2)*ζ-1)*Dmid + k*(k-1)*ζ*Dlo, Dhi, Dmid
        Thi, Tmid, Tlo = Nhi/Dhi, Thi, Tmid
        if norm(α+k+1) < eps(absα+k+1)
            return Thi
        end
        Nhi /= α+k+1
        Dhi /= α+k+1
        k += 1
    end
    k < kmax || @warn "Rational approximation to "*pFq2string(Val{1}(), Val{1}())*" reached the maximum type of ("*string(kmax, ", ", kmax)*")."
    return isfinite(Thi) ? Thi : isfinite(Tmid) ? Tmid : Tlo
end

# ₀F₂(α,β;z)
function pFqdrummond(::Tuple{}, β::Tuple{T1, T1}, z::T2; kmax::Int = KMAX) where {T1, T2}
    (α, β) = β
    T = promote_type(T1, T2)
    if norm(z) < eps(real(T)) || norm(α) < eps(real(T)) || norm(β) < eps(real(T))
        return one(T)
    end
    ζ = inv(z)
    Nlo = α*β*ζ
    Dlo = α*β*ζ
    Tlo = Nlo/Dlo
    k = 0
    Nmid2 = (ζ*(k+2)*(α+k+1)*(β+k+1)-1)*Nlo + (2*(α+1)*(β+1))*ζ
    Dmid2 = (ζ*(k+2)*(α+k+1)*(β+k+1)-1)*Dlo
    Tmid2 = Nmid2/Dmid2
    k = 1
    Nmid1 = (ζ*(k+2)*(α+k+1)*(β+k+1)-1)*Nmid2 + ζ*k*((k+1)*(α+β+2k)+(α+k)*(β+k)+α+β+3k+2)*Nlo + (3*(α+β+3)+(α+1)*(β+1))*ζ
    Dmid1 = (ζ*(k+2)*(α+k+1)*(β+k+1)-1)*Dmid2 + ζ*k*((k+1)*(α+β+2k)+(α+k)*(β+k)+α+β+3k+2)*Dlo
    Tmid1 = Nmid1/Dmid1
    k = 2
    Nhi = (ζ*(k+2)*(α+k+1)*(β+k+1)-1)*Nmid1 + ζ*k*((k+1)*(α+β+2k)+(α+k)*(β+k)+α+β+3k+2)*Nmid2 + ζ*k*(k-1)*(3k+α+β+1)*Nlo + (14+2*(α+β))*ζ
    Dhi = (ζ*(k+2)*(α+k+1)*(β+k+1)-1)*Dmid1 + ζ*k*((k+1)*(α+β+2k)+(α+k)*(β+k)+α+β+3k+2)*Dmid2 + ζ*k*(k-1)*(3k+α+β+1)*Dlo
    Thi = Nhi/Dhi
    k = 3
    Nhi, Nmid1, Nmid2, Nlo = (ζ*(k+2)*(α+k+1)*(β+k+1)-1)*Nhi + ζ*k*((k+1)*(α+β+2k)+(α+k)*(β+k)+α+β+3k+2)*Nmid1 + ζ*k*(k-1)*(3k+α+β+1)*Nmid2 + ζ*k*(k-1)*(k-2)*Nlo + 6ζ, Nhi, Nmid1, Nmid2
    Dhi, Dmid1, Dmid2, Dlo = (ζ*(k+2)*(α+k+1)*(β+k+1)-1)*Dhi + ζ*k*((k+1)*(α+β+2k)+(α+k)*(β+k)+α+β+3k+2)*Dmid1 + ζ*k*(k-1)*(3k+α+β+1)*Dmid2 + ζ*k*(k-1)*(k-2)*Dlo, Dhi, Dmid1, Dmid2
    Thi, Tmid1, Tmid2, Tlo = Nhi/Dhi, Thi, Tmid1, Tmid2
    k += 1
    while k < kmax && errcheck(Tmid1, Thi, 8eps(real(T)))
        Nhi, Nmid1, Nmid2, Nlo = (ζ*(k+2)*(α+k+1)*(β+k+1)-1)*Nhi + ζ*k*((k+1)*(α+β+2k)+(α+k)*(β+k)+α+β+3k+2)*Nmid1 + ζ*k*(k-1)*(3k+α+β+1)*Nmid2 + ζ*k*(k-1)*(k-2)*Nlo, Nhi, Nmid1, Nmid2
        Dhi, Dmid1, Dmid2, Dlo = (ζ*(k+2)*(α+k+1)*(β+k+1)-1)*Dhi + ζ*k*((k+1)*(α+β+2k)+(α+k)*(β+k)+α+β+3k+2)*Dmid1 + ζ*k*(k-1)*(3k+α+β+1)*Dmid2 + ζ*k*(k-1)*(k-2)*Dlo, Dhi, Dmid1, Dmid2
        Thi, Tmid1, Tmid2, Tlo = Nhi/Dhi, Thi, Tmid1, Tmid2
        k += 1
    end
    k < kmax || @warn "Rational approximation to "*pFq2string(Val{0}(), Val{2}())*" reached the maximum type of ("*string(kmax, ", ", kmax)*")."
    return isfinite(Thi) ? Thi : isfinite(Tmid1) ? Tmid1 : isfinite(Tmid2) ? Tmid2 : Tlo
end

# ₂F₁(α,β,γ;z)
function pFqdrummond(α::Tuple{T1, T1}, β::Tuple{T2}, z::T3; kmax::Int = KMAX) where {T1, T2, T3}
    γ = β[1]
    (α, β) = α
    T = promote_type(T1, T2, T3)
    absα = abs(T(α))
    absβ = abs(T(β))
    if norm(z) < eps(real(T)) || norm(α*β) < eps(absα*absβ)
        return one(T)
    end
    μlo = T(α*β)/T(γ)
    Tlo = one(T)
    μmid = inv((2)*(γ+1)-(α+1)*(β+1)*z)
    Tmid = Tlo + (γ+1)*2z*μmid*μlo
    if norm((α+1)*(β+1)) < eps((absα+1)*(absβ+1))
        return Tmid
    end
    μmid *= (α+1)*(β+1)
    μhi = inv((3)*(γ+2)-((α+2)*(β+2)+(α+β+3))*z + ((γ+4)-(α+β+3)*z)*z*μmid)
    Thi = (((3)*(γ+2)-((α+2)*(β+2)+(α+β+3))*z)*Tmid + (((γ+4)-(α+β+3)*z)*z*Tlo + (γ+4)*z*z*μlo)*μmid)*μhi
    if norm((α+2)*(β+2)) < eps((absα+2)*(absβ+2))
        return Thi
    end
    μhi *= (α+2)*(β+2)
    k = 2
    μlo2 = μlo
    μhi, μmid, μlo = inv((k+2)*(γ+k+1)-((α+k+1)*(β+k+1)+k*(α+β+2k+1))*z + k*(((γ+2k+2)-(α+β+3k)*z)*z + (k-1)*(1-z)*z*z*μmid)*μhi), μhi, μmid
    Thi, Tmid, Tlo = (((k+2)*(γ+k+1)-((α+k+1)*(β+k+1)+k*(α+β+2k+1))*z)*Thi + (k*((γ+2k+2)-(α+β+3k)*z)*z*Tmid + (k*(k-1)*(1-z)*z*z*Tlo + 2z*z*z*μlo2)*μlo)*μmid)*μhi, Thi, Tmid
    if norm((α+k+1)*(β+k+1)) < eps((absα+k+1)*(absβ+k+1))
        return Thi
    end
    μhi *= (α+k+1)*(β+k+1)
    k += 1
    while k < kmax && errcheck(Tmid, Thi, 8eps(real(T)))
        μhi, μmid, μlo = inv((k+2)*(γ+k+1)-((α+k+1)*(β+k+1)+k*(α+β+2k+1))*z + k*(((γ+2k+2)-(α+β+3k)*z)*z + (k-1)*(1-z)*z*z*μmid)*μhi), μhi, μmid
        Thi, Tmid, Tlo = (((k+2)*(γ+k+1)-((α+k+1)*(β+k+1)+k*(α+β+2k+1))*z)*Thi + k*(((γ+2k+2)-(α+β+3k)*z)*z*Tmid + (k-1)*(1-z)*z*z*Tlo*μlo)*μmid)*μhi, Thi, Tmid
        if norm((α+k+1)*(β+k+1)) < eps((absα+k+1)*(absβ+k+1))
            return Thi
        end
        μhi *= (α+k+1)*(β+k+1)
        k += 1
    end
    k < kmax || @warn "Rational approximation to "*pFq2string(Val{2}(), Val{1}())*" reached the maximum type of ("*string(kmax, ", ", kmax)*")."
    return isfinite(Thi) ? Thi : isfinite(Tmid) ? Tmid : Tlo
end

# ₘFₙ(α;β;z)
function pFqdrummond(α::AbstractVector{T1}, β::AbstractVector{T2}, z::T3, args...; kwds...) where {T1, T2, T3}
    pFqdrummond(Tuple(α), Tuple(β), z, args...; kwds...)
end
function pFqdrummond(α::NTuple{p, Any}, β::NTuple{q, Any}, z, args...; kwds...) where {p, q}
    T1 = isempty(α) ? Any : mapreduce(typeof, promote_type, α)
    T2 = isempty(β) ? Any : mapreduce(typeof, promote_type, β)
    pFqdrummond(T1.(α), T2.(β), z, args...; kwds...)
end
function pFqdrummond(α::NTuple{p, T1}, β::NTuple{q, T2}, z::T3; kmax::Int = KMAX) where {p, q, T1, T2, T3}
    T = promote_type(eltype(α), eltype(β), T3)
    absα = abs.(T.(α))
    if norm(z) < eps(real(T)) || norm(prod(α)) < eps(real(T)(prod(absα)))
        return one(T)
    end
    ζ = inv(z)
    r = max(p, q+1)
    N = zeros(T, r+2)
    D = zeros(T, r+2)
    R = zeros(T, r+2)
    N[r+2] = prod(β)*ζ/prod(α)
    D[r+2] = prod(β)*ζ/prod(α)
    R[r+2] = N[r+2]/D[r+2]
    absα = absα .+ 1
    α = α .+ 1
    β = β .+ 1
    err = real(T)(prod(absα))
    P = zeros(T, p+1)
    P[1] = T(prod(α))
    Q = zeros(T, q+2)
    Q[1] = T(2*prod(β))
    k = 0
    @inbounds while k ≤ r || (k < kmax && errcheck(R[r+1], R[r+2], 8eps(real(T))))
        for j in 1:r+1
            N[j] = N[j+1]
            D[j] = D[j+1]
            R[j] = R[j+1]
        end
        t1 = zero(T)
        for j in 0:min(k, q+1)
            t1 += Q[j+1]*N[r+1-j]
        end
        if k ≤ q+1
            t1 += Q[k+1]
        end
        t2 = zero(T)
        t2 += P[1]*N[r+1]
        for j in 1:min(k, p)
            t2 += P[j+1]*(N[r-j+2] + N[r-j+1])
        end
        N[r+2] = ζ*t1-t2
        t1 = zero(T)
        for j in 0:min(k, q+1)
            t1 += Q[j+1]*D[r-j+1]
        end
        t2 = zero(T)
        t2 += P[1]*D[r+1]
        for j in 1:min(k, p)
            t2 += P[j+1]*(D[r-j+2] + D[r-j+1])
        end
        D[r+2] = ζ*t1-t2
        R[r+2] = N[r+2]/D[r+2]
        if norm(P[1]) < eps(err)
            return R[r+2]
        end
        N[r+2] /= P[1]
        D[r+2] /= P[1]
        k += 1
        absα = absα .+ 1
        α = α .+ 1
        β = β .+ 1
        err = real(T)(prod(absα))
        t = T(prod(α))
        for j in 1:p
            s = ((k-j+1)*t - k*P[j])/j
            P[j] = t
            t = s
        end
        P[p+1] = t
        t = T((k+2)*prod(β))
        for j in 1:q+1
            s = ((k-j+1)*t - k*Q[j])/j
            Q[j] = t
            t = s
        end
        Q[q+2] = t
    end
    k < kmax || @warn "Rational approximation to "*pFq2string(Val{p}(), Val{q}())*" reached the maximum type of ("*string(kmax, ", ", kmax)*")."
    return isfinite(R[r+2]) ? R[r+2] : R[r+1]
end

@deprecate drummond0F0(x; kwds...) pFqdrummond((), (), x; kwds...) false
@deprecate drummond1F0(α, x; kwds...) pFqdrummond((α, ), (), x; kwds...) false
@deprecate drummond0F1(β, x; kwds...) pFqdrummond((), (β, ), x; kwds...) false
@deprecate drummond2F0(α, β, x; kwds...) pFqdrummond((α, β), (), x; kwds...) false
@deprecate drummond1F1(α, β, x; kwds...) pFqdrummond((α, ), (β, ), x; kwds...) false
@deprecate drummond0F2(α, β, x; kwds...) pFqdrummond((), (α, β), x; kwds...) false
@deprecate drummond2F1(α, β, γ, x; kwds...) pFqdrummond((α, β), (γ, ), x; kwds...) false
