package com.example.avramescucristian.plated;


        import java.util.List;
        import java.util.Vector;


        import android.content.Context;
        import android.os.Bundle;
        import android.support.v4.app.Fragment;
        import android.support.v4.view.ViewPager;
        import android.support.v4.view.ViewPager.OnPageChangeListener;
        import android.support.v7.app.ActionBarActivity;
        import android.view.View;
        import android.widget.HorizontalScrollView;
        import android.widget.TabHost;
        import android.widget.TabHost.OnTabChangeListener;
        import android.widget.TabHost.TabContentFactory;

public class Menu1 extends ActionBarActivity implements
        OnTabChangeListener, OnPageChangeListener {

    private TabHost tabHost;
    private ViewPager viewPager;
    private MyFragmentPagerAdapter myViewPagerAdapter;
    int i = 0;

    // fake content for tabhost
    class FakeContent implements TabContentFactory {
        private final Context mContext;

        public FakeContent(Context context) {
            mContext = context;
        }

        @Override
        public View createTabContent(String tag) {
            View v = new View(mContext);
            v.setMinimumHeight(0);
            v.setMinimumWidth(0);
            return v;
        }
    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.menu);

        i++;

        // init tabhost
        this.initializeTabHost(savedInstanceState);

        // init ViewPager
        this.initializeViewPager();

    }

    private void initializeViewPager() {
        List<Fragment> fragments = new Vector<Fragment>();

        fragments.add(new ShowProducts());
        fragments.add(new Bill());

        this.myViewPagerAdapter = new MyFragmentPagerAdapter(
                getSupportFragmentManager(), fragments);
        this.viewPager = (ViewPager) super.findViewById(R.id.viewPager);
        this.viewPager.setAdapter(this.myViewPagerAdapter);
        this.viewPager.setOnPageChangeListener(this);

        onRestart();

    }

    private void initializeTabHost(Bundle args) {

        tabHost = (TabHost) findViewById(android.R.id.tabhost);
        tabHost.setup();

        TabHost.TabSpec tabSpec1 , tabSpec2;
        tabSpec1 = tabHost.newTabSpec(" First Tab ");
        tabSpec1.setIndicator("Menu");
        tabSpec1.setContent(new FakeContent(this));

        tabSpec2 = tabHost.newTabSpec(" Second Tab ");
        tabSpec2.setIndicator("Bill");
        tabSpec2.setContent(new FakeContent(this));

        tabHost.addTab(tabSpec1);
        tabHost.addTab(tabSpec2);

        tabHost.setOnTabChangedListener(this);
    }

    @Override
    public void onTabChanged(String tabId) {
        int pos = this.tabHost.getCurrentTab();
        this.viewPager.setCurrentItem(pos);

        HorizontalScrollView hScrollView = (HorizontalScrollView) findViewById(R.id.hScrollView);
        View tabView = tabHost.getCurrentTabView();
        int scrollPos = tabView.getLeft()
                - (hScrollView.getWidth() - tabView.getWidth()) / 2;
        hScrollView.smoothScrollTo(scrollPos, 0);

    }

    @Override
    public void onPageScrollStateChanged(int arg0) {
    }

    @Override
    public void onPageScrolled(int arg0, float arg1, int arg2) {
    }

    @Override
    public void onPageSelected(int position) {
        this.tabHost.setCurrentTab(position);
    }

}
