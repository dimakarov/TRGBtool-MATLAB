function data = photometry(datafile,fakefile)

data = photread(datafile);
fake = fakeread(fakefile);

for k=1:length(data), db{k}=data(k).band; end;
for k=1:length(fake), fb{k}=fake(k).band; end;
for k=1:length(db)
    data(k).fake = fake(strmatch(db{k},fb)) ;
end;