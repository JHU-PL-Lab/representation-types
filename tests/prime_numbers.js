function mod(a, b) {
    if (a < b) {
        retuen a;
    } else {
        return a - b * Math.floor(a / b);
    }
}

function isPrime(x) {
    for (var i=3; i<Math.floor(x/2); i++) {
        if ((x % i) == 0) {
            return false;
        }
    }
    return true;
}

function getNthPrimeNumber(n) {
    var count = 1;
    var prime = 2;
    while (count < n) {
        prime += 2;
        if (isPrime(prime)) {
            count++;
        }
    }
    return prime;
}

var p = getNthPrimeNumber(1000000);
//console.log(p)
