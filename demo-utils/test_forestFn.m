N = 10000;
F = 5313;
X = single(rand(N, F));
y = randi(2, [N 1]);
N = 50000;
F = 5313;
Xtest = single(rand(N, F));

seed = 10;
s = RandStream('mt19937ar','Seed',seed);
RandStream.setGlobalStream(s);
forest1 = forestTrain(X, y, 'M', 2);

seed = 10;
s = RandStream('mt19937ar','Seed',seed);
RandStream.setGlobalStream(s);
forest2 = forestTrainFn(matrixToTreeData(X), y, 'M', 2);

assert(isequal(forest1, forest2), 'Forests not same\n');

hs1 = forestApply( Xtest, forest1, [], [], []);
hs2 = forestApplyFnMemory( matrixToTreeData(Xtest), forest1, [], [], [], 1);
hs3 = forestApplyFnMemory( matrixToTreeData(Xtest), forest1, [], [], [], 0);

assert(isequal(hs1, hs2), 'hs1 ~= hs2. Testing results not same!\n');
assert(isequal(hs1, hs3), 'hs1 ~= hs3. Testing results not same!\n');
