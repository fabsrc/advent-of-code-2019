<?php

function is_valid_password_1(int $password): bool
{
    return preg_match('/(\d)\1/', $password) &&
        preg_match('/^0*1*2*3*4*5*6*7*8*9*$/', $password);
}

assert(is_valid_password_1(111111) === true);
assert(is_valid_password_1(123789) === false);
assert(is_valid_password_1(223450) === false);


function is_valid_password_2(int $password): bool
{
    return preg_match('/(\d)\1/', preg_replace('/(\d)\1\1\1*/', '', $password)) &&
        preg_match('/^0*1*2*3*4*5*6*7*8*9*$/', $password);
}

assert(is_valid_password_2(112233) === true);
assert(is_valid_password_2(123444) === false);
assert(is_valid_password_2(111122) === true);


function count_valid_passwords(int $min, int $max)
{
    $count_1 = 0;
    $count_2 = 0;

    foreach (range($min, $max) as $password) {
        if (is_valid_password_1($password)) {
            $count_1++;
        }

        if (is_valid_password_2($password)) {
            $count_2++;
        }
    }

    return [$count_1, $count_2];
}

if ($argv[1]) {
    list($min, $max) = array_map('intval', explode('-', $argv[1]));
    echo(join("\n", count_valid_passwords($min, $max)) . "\n");
}
