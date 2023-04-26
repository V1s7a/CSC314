//////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

#include <stdio.h>
#include <time.h>
#include <stdlib.h>


int sumOfSumsAtoB(int a, int b); // prototype for library function (normally you would have this in an #include .h header file for the library)

// ***** Uncomment this when ready to test your tweaked assembly version 
int sumOfSumsAtoB_tweaked(int a, int b); // prototype for assembly version of the function


int dummyFunction(int a, int b) {
    int x,y,z;
    return x;
}

void validationTest(int testA, int testB) {
    printf("\n");
    printf("sumOfSumsAtoB(%d,%d) = %d\n", testA, testB, sumOfSumsAtoB(testA,testB));    
    // uncomment below when testing tweaked funciton to compare with original to
    // verify that your tweaked function still produces the same result as original
    printf("sumOfsumsAtoB_tweaked(%d,%d) = %d\n", testA, testB, sumOfSumsAtoB_tweaked(testA,testB));// <--------- UNCOMMENT for testing tweaked function *********
}

#define N_TESTS 200000
#define TEST_A 1
#define TEST_B 100000

void main() {
    int k, result;
    clock_t before, after;
    long double originalTime, tweakedTime, overheadTime;

    // ***** Make sure you uncommment the printf for testing tweaked funciton in the validationTest funciton above
    printf("Verifying the functions work...\n\n");
    
    validationTest(1,8);
    validationTest(1,19);
    validationTest(11,1111);
    validationTest(99,999);
    validationTest(1,42);
    validationTest(13,42);
    
 
 
  
    printf("\n\nSpeed testing function, by running it %d times, with A=%d and B=%d...\n\n", N_TESTS, TEST_A, TEST_B);

    // measure overhead time for loop with dummy test function...
    // we will subtract this from the test time measurements to more accurately
    // measure only the time spend within the body of the tested functions
    printf("\nMeasuring time to run test loop without using the function...\n");
    before = clock();
    for(k=0;k<N_TESTS;k++) {
            dummyFunction(TEST_A,TEST_B);
    }
    after = clock();
    overheadTime = 1000.0 * ((long double)(after - before)) / ((long double) CLOCKS_PER_SEC); // time in milliseconds
    printf("Overhead time = %.2Lf milliseconds\n", overheadTime);

    // run speed test of original function...
    printf("\nMeasuring time to run the original C function in the test loop...\n");
    before = clock();
    for(k=0;k<N_TESTS;k++) {
            result = sumOfSumsAtoB(TEST_A,TEST_B);
    }
    after = clock();
    originalTime = 1000.0 * ((long double)(after - before)) / ((long double) CLOCKS_PER_SEC); // time in milliseconds
    originalTime = originalTime - overheadTime;
    printf("Total time for original function = %.2Lf milliseconds\n", originalTime);  
    
    
    // run speed test of your tweaked assembly version of the function...
    // ***** uncomment below when ready to run the tests on your version of the function
    
    printf("\nMeasuring time to run the tweaked asm function in the test loop...\n");
    before = clock();
    for(k=0;k<N_TESTS;k++) {
            result = sumOfSumsAtoB_tweaked(TEST_A,TEST_B);
    }
    after = clock();
    tweakedTime = 1000.0 * ((long double)(after - before)) / ((long double) CLOCKS_PER_SEC); // time in milliseconds
    tweakedTime = tweakedTime - overheadTime;
    printf("Total time for teaked function = %.2Lf milliseconds\n", tweakedTime);    
    
    double timeDifference = originalTime - tweakedTime;
    double speedupFactor = originalTime / tweakedTime;
    printf("\n======================================================\n\n");
    printf("Tweaked version took %.2lf milliseconds less time.\n",timeDifference);
    printf("Tweaked version was %.2lf times faster.\n",speedupFactor);
    
}

//////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

