#!/usr/bin/env bats

RUNOPTS="-i --rm"
IMG="dgricci/proj:$(< VERSION)"

setup() {
    echo "setting up ..."
}

# See https://github.com/OSGeo/proj.4/blob/master/nad/testvarious
# See https://github.com/OSGeo/proj.4/blob/master/nad/tv_out.dist

@test "Test raw ellipse to raw ellipse" {
    local pt1="79d58'00.000\\\"W 37d02'00.000\\\"N 0.0"
    run bash -c "echo \"${pt1}\" | docker run ${RUNOPTS} ${IMG} cs2cs +proj=latlong +ellps=clrk66 +to +proj=latlong +ellps=bessel"
    [[ "$(echo ${output} | tr -d '\r\n' | tr -s '[ \t]' ';')" == "79d58'W;37d2'N;0.000" ]]
    local pt2="79d58'00.000\\\"W 36d58'00.000\\\"N 0.0"
    run bash -c "echo \"${pt2}\" | docker run ${RUNOPTS} ${IMG} cs2cs +proj=latlong +ellps=clrk66 +to +proj=latlong +ellps=bessel"
    [[ "$(echo ${output} | tr -d '\r\n' | tr -s '[ \t]' ';')" == "79d58'W;36d58'N;0.000" ]]
}

@test "Test NAD27 to raw ellipse" {
    local pt1="79d00'00.000\\\"W 35d00'00.000\\\"N 0.0"
    run bash -c "echo \"${pt1}\" | docker run ${RUNOPTS} ${IMG} cs2cs +proj=latlong +datum=NAD27 +to +proj=latlong +ellps=bessel"
    [[ "$(echo ${output} | tr -d '\r\n' | tr -s '[ \t]' ';')" == "79dW;35dN;0.000" ]]
}

@test "Between two 3parameter approximations on same ellipsoid" {
    local pt1="0d00'00.000\\\"W 0d00'00.000\\\"N 0.0"
    local pt2="79d00'00.000\\\"W 45d00'00.000\\\"N 0.0"
    run bash -c "echo \"${pt1}\" | docker run ${RUNOPTS} ${IMG} cs2cs +proj=latlong +ellps=bessel +towgs84=5,0,0 +to +proj=latlong +ellps=bessel +towgs84=1,0,0"
    [[ "$(echo ${output} | tr -d '\r\n' | tr -s '[ \t]' ';')" == "0dE;0dN;4.000" ]]
    run bash -c "echo \"${pt2}\" | docker run ${RUNOPTS} ${IMG} cs2cs +proj=latlong +ellps=bessel +towgs84=5,0,0 +to +proj=latlong +ellps=bessel +towgs84=1,0,0"
    [[ "$(echo ${output} | tr -d '\r\n' | tr -s '[ \t]' ';')" == "78d59'59.821\"W;44d59'59.983\"N;0.540" ]]
}

# See https://github.com/OSGeo/proj.4/blob/master/nad/testIGNF
# See https://github.com/OSGeo/proj.4/blob/master/nad/proj_outIGNF.dist

@test "NTFG to RGF93G" {
    local pt1="3.300866856 43.4477976569 0.0000"
    run bash -c "echo \"${pt1}\" | docker run ${RUNOPTS} ${IMG} cs2cs +init=IGNF:NTFG +to +init=IGNF:RGF93G"
    [[ "$(echo ${output} | tr -d '\r\n' | tr -s '[ \t]' ';')" == "3d18'0.915\"E;43d26'52.077\"N;0.000" ]]
}

teardown() {
    echo "tearing down !"
}

