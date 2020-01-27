data {
  int <lower=0> N; //number of observations
  
  //Exposure interval
  real EL[N]; //lower end of exposure periods
  real ER[N]; //upper end of exposure period
 
  //symptom onset interval
  real SL[N];
  real SR[N];

  //end of viral shedding interval
  real VL[N];
  real VR[N];

}


parameters {
  real lm; //the mean of the log normal distribution on the log scale
  real <lower=0> lsd; //the sd of the log normal distribution on the log scale

  real v_lm;//mean for shedding 
  real <lower=0> v_lsd; //sd for shedding

  real E[N]; //the time of the infecting exposure



}

transformed parameters {
  real LEN_IP_LONG[N]; //the maximum length of the incubation period
  real LEN_IP_SHORT[N]; //the shortest length of the incubation period

  real LEN_VSP_LONG[N]; //the maximum consistent length of viral shedding
  real LEN_VSP_SHORT[N]; //the shortest consistent length of viral shedding

  //Calculate incubation period range.
  for (i in 1:N) {
    LEN_IP_LONG[i] <- SR[i]-E[i]+0.001;

    if (E[i]<SL[i]) {
      LEN_IP_SHORT[i] <- SL[i] - E[i]+0.001;
    } else {
      LEN_IP_SHORT[i] <- 0.001;
    }
  }
 

  //Calculate viral shedding period range
  for (i in 1:N) {
    LEN_VSP_LONG[i] <- VR[i]-E[i]+0.001;

    if (E[i]<VL[i]) {
      LEN_VSP_SHORT[i] <- VL[i] - E[i]+0.001;
    } else {
      LEN_VSP_SHORT[i] <- 0.001;
    }
  }
 
}

model {
  
  lm ~ normal(0,1000);//uninformative prior
  lsd ~ uniform(0,5); //uninformative prior

  v_lm ~ normal(0,1000);//uninformative prior
  v_lsd ~ uniform(0,5); //uninformative prior

  E~uniform(EL,ER); //exposure in exposure period
  

  //increment probability based on the probability mass in between the possible ranges for each distrbution
  for (i in 1:N) {
    increment_log_prob(log(lognormal_cdf(LEN_IP_LONG[i], lm, lsd) - lognormal_cdf(LEN_IP_SHORT[i], lm, lsd)));
    increment_log_prob(log(lognormal_cdf(LEN_VSP_LONG[i],v_lm, v_lsd) - lognormal_cdf(LEN_VSP_SHORT[i],v_lm, v_lsd)));
  }
  
}